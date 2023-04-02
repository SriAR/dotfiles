import requests
import time
import os
import subprocess
import re
import json

def notify(message):
    if message == 'no result from dblp':
        os.system("dunstify -a \"Evrart Claire\" \"You can't find your paper?\" \"Of course I'll help you find your publication, Harry\" -i /home/cs/dotfiles/.assets/evrart_claire.png")

    if message == 'bibtex saved':
        os.system("dunstify -a \"Evrart Claire\" \"Found your bibtex\" \"My workers have found your bibtex file, Harry\" -i /home/cs/dotfiles/.assets/evrart_claire.png")

    if message == 'couldnt download pdf':
        os.system("dunstify -a \"Evrart Claire\" \"Couldn't download pdf\" \"My workers could not download your pdf, Harry\" -i /home/cs/dotfiles/.assets/evrart_claire.png")

    if message == 'downloaded pdf':
        os.system("dunstify -a \"Evrart Claire\" \"Downloaded your pdf\" \"My workers have found your pdf, Harry\" -i /home/cs/dotfiles/.assets/evrart_claire.png")


def search_dblp(query):
    url = f'https://dblp.org/search/publ/api?q={"+".join(query.split())}&format=json'
    response = requests.get(url)
    data = response.json()

    if data['result']['hits']['@total'] == '0' :
        notify("no result from dblp")
        return

    hits = data['result']['hits']['hit']

    if isinstance(hits, dict):
        hits = [hits]

    options = []
    for hit in hits:
        option = build_option(hit)
        options.append(option)

    selected_option = select_option(options)

    if not selected_option:
        return

    filename = subprocess.check_output(['rofi', '-dmenu', '-p', 'Enter filename:']).decode().strip()

    if not filename:
        return

    key = extract_key(selected_option)
    bibtex = get_bibtex(key)
    save_bibtex(filename, bibtex)

    doi = extract_doi(selected_option)
    if doi != "N/A" and turn_on_vpn():
        download_pdf_from_scihub(doi,filename)
    else:
        notify("couldnt download pdf")

def build_option(hit):
    key = hit['info']['key']
    title = hit['info']['title']
    authors = hit['info']['authors']['author']
    if isinstance(authors, dict):
        authors = [authors]
    authors = ', '.join([a['text'] for a in authors])
    year = hit['info']['year']
    try:
        venue = hit['info']['venue']
    except:
        venue = 'N/A'
    try:
        doi = hit['info']['doi']
    except:
        doi = 'N/A'
    option = f'{key} - {title}, {authors}, {venue}, {year} - {doi}'
    return option

def select_option(options):
    rofi = subprocess.Popen(['rofi', '-dmenu', '-theme', 'pdfs', '-i', '-p', 'Select a publication'], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    selected_option, _ = rofi.communicate(input='\n'.join(options).encode('utf-8'))
    return selected_option.decode()

def extract_key(selected_option):
    key = re.search(r'^(\S+) -', selected_option).group(1)
    return key

def get_bibtex(key):
    url = f'http://dblp.org/rec/{key}.bib'
    response = requests.get(url)
    return response.text

def save_bibtex(filename, bibtex):
    if not filename.endswith('.bib'):
        filename += '.bib'

    with open(filename, 'w') as file:
        file.write(bibtex)

    notify("bibtex saved")

def extract_doi(selected_option):
    doi = re.search(r'- (\S+)$', selected_option).group(1)
    return doi

def turn_on_vpn():
    status = subprocess.check_output(['protonvpn-cli', 'status']).decode()
    if 'No active' in status:
        subprocess.Popen(['protonvpn-cli', 'connect', '--fastest'])
    time.sleep(3)
    status = subprocess.check_output(['protonvpn-cli', 'status']).decode()
    if 'No active' in status:
        return False
    return True

def download_pdf_from_scihub(doi,filename):
    url = f'https://sci-hub.ru/{doi}'
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}
    response = requests.get(url, headers=headers)
    content = response.content.decode('utf-8')

    if response.status_code == 200 and 'article not found' not in content:
        pdfurl = re.search(r'location\.href=\'(.*?)\'', content).group(1)
        pdfurl = 'https://sci-hub.ru' + pdfurl
        pdfurl = pdfurl.split('?')[0]
        pdfresponse = requests.get(pdfurl, headers=headers)

        if pdfresponse.status_code == 200:
            with open(filename+'.pdf', 'wb') as file:
                file.write(pdfresponse.content)
                notify('downloaded pdf')
        else:
            notify('couldnt download pdf')
    else:
        notify('couldnt download pdf')


def download_arxiv_pdf(arxiv_id, filename):
    url = f'https://arxiv.org/pdf/{arxiv_id}.pdf'
    response = requests.get(url)
    if response.status_code == 200:
        with open(f'{filename}.pdf', 'wb') as f:
            f.write(response.content)
        print(f'Downloaded {filename}.pdf')
    else:
        print(f'PDF for {arxiv_id} is not available.')

if __name__ == '__main__':
    #  query = subprocess.check_output(['rofi', '-dmenu', '-theme', 'pdfs', '-i', '-p', 'Enter your query:', '-sort']).decode().strip()
    #  search_dblp(query)
