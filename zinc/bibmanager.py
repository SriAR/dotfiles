import bibtexparser
from bibtexparser.bparser import BibTexParser
from bibtexparser.customization import homogenize_latex_encoding

from pathlib import Path
import json

def pp(dic):
    return json.dumps(dic,indent=4)

class BibEntry:

    def __init__(self, bibfile: Path):
        self.bibfile = bibfile
        self.asdict = self.load_entries()
        self.type = self.asdict['ENTRYTYPE']
        self.fixbib()

    def load_entries(self):
        parser = BibTexParser()
        parser.customization = homogenize_latex_encoding
        with self.bibfile.open() as fp:
            entry = bibtexparser.load(fp, parser=parser).entries[0]
        return entry

    def fixbib(self):
        if self.type == 'inproceedings':
            self.fixconference()
        elif self.type == 'article':
            self.fixjournal()

    def fixconference(self):
        title = self.fixtitle(self.asdict['title'])
        booktitle = self.fixconfname(self.asdict['booktitle'])

        newdict = {
                'title': title,
                'booktitle': booktitle,
                }

        for entry in ['ID','ENTRYTYPE','author','year','pages','url','doi']:
            if entry in self.asdict.keys():
                newdict[entry] = self.asdict[entry]
        self.asdict = newdict

        #  self.asdict = {
        #          'ID': self.asdict['ID'],
        #          'ENTRYTYPE': self.asdict['ENTRYTYPE'],
        #          'author': self.asdict['author'],
        #          'title': title,
        #          'booktitle': booktitle,
        #          'year': self.asdict['year'],
        #          'pages': self.asdict['pages'],
        #          'url': self.asdict['url'],
        #          'doi': self.asdict['doi'],
        #          }

    def fixtitle(self, title):
        return title.replace('\n', ' ')

    def fixconfname(self, confname):
        confname = ''.join(filter(lambda x: str.isalnum(x), confname)).lower()
        confdict = {
                'symposiumondiscretealgorithms':
                'Symposium on Discrete Algorithms (SODA)',
                'symposiumontheoryofcomputing':
                'Symposium on Theory of Computing (STOC)',
                'foundationsofcomputerscience':
                'Foundations of Computer Science (FOCS)',
                }

        for key in confdict.keys():
            if key in confname:
                return confdict[key]
        else:
            return confname

    def fixjournal(self):
        pass

    def __repr__(self):
        return pp(self.asdict)

class Bibs:

    def __init__(self, bibdirstr: str):
        self.bibdir = Path(bibdirstr)
        if not self.bibdir.is_dir():
            print('Bibliography directory wer? Not at ' + bibdirstr)
            exit(1)

        self.bibs = self.extract_bibs()

    def extract_bibs(self):
        biblist = []
        for bibfile in self.bibdir.iterdir():
            biblist.append(BibEntry(bibfile))
        return biblist

    def __repr__(self):
        return '\n'.join([repr(x) for x in self.bibs])

class GetBib:

    def __init__(self, query: str):
        import requests
        #  response = requests.get('https://dblp.org/search/publ/api?q='+query+'&format=json').json()
        #  allhits = response['result']['hits']['hit']
        #  wantedone = allhits[0]['info']['key']
        #  print(pp(wantedone))
        #  wantedone='conf/soda/ChiplunkarHKV23'
        #  bibresponse = requests.get('https://dblp.org/rec/'+wantedone+'.bib')
        #  with open('/tmp/asdada', 'w') as fp:
        #      fp.write(bibresponse.text)
        #  print(bibresponse.text)
        parsed = BibEntry(Path('/tmp/asdada'))
        print(parsed)


x = GetBib('Online Min Max Paging')

#  bibdir = '/tmp/bib'
#
#  fullbib = Bibs(bibdir)
#  print(fullbib)
