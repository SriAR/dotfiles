import bibtexparser
from pathlib import Path
import json
import yaml

with open('confs.yaml') as f:
    confdict = yaml.safe_load(f)

def pp(dic):
    return json.dumps(dic,indent=4)

def read_bib_file(bibfile: Path, customparser=False):
    if customparser:
        from bibtexparser.bparser import BibTexParser
        from bibtexparser.customization import homogenize_latex_encoding
        parser = BibTexParser()
        parser.customization = homogenize_latex_encoding
        with bibfile.open() as fp:
            entries = bibtexparser.load(fp, parser=parser).entries
    else:
        with bibfile.open() as fp:
            entries = bibtexparser.load(fp).entries
    return entries

class BibEntry:

    def __init__(self, inputbib: dict):
        self.inputbib = inputbib
        self.type = inputbib['ENTRYTYPE']
        self.citekey = inputbib['ID']
        self.authors = self.fixauthors(inputbib['author'])
        self.title = self.fixtitle(inputbib['title'])
        self.year = inputbib['year']

    def fixauthors(self, authors):
        authorlist = authors.split(' and ')
        authorlist = list(map(lambda x: x.strip(), authorlist))
        return ' and '.join(authorlist)

    def fixtitle(self, title):
        return title.replace('\n', ' ')

    def makebib(self):
        return {
                'ENTRYTYPE': self.type,
                'ID': self.citekey,
                'author': self.authors,
                'title': self.title,
                'year': self.year
                }

    def __repr__(self):
        return pp(self.makebib())

class Conference(BibEntry):

    def __init__(self, inputbib: dict):
        super(Conference, self).__init__(inputbib)
        self.conference_init()

    def conference_init(self):
        self.conference = self.fixconference(self.inputbib['booktitle'])
        for key in ['pages', 'url', 'doi', 'biburl']:
            try:
                setattr(self, key, self.inputbib[key])
            except:
                print(f'{self.citekey} has no {key}')

    def fixconference(self, confname):
        confname = ''.join(filter(lambda x: str.isalnum(x), confname)).lower()

        for key in confdict.keys():
            if key in confname:
                return confdict[key]
        else:
            print(f'{self.citekey} has no {confname} in dict')
            return confname

    def makebib(self):
        bibtoreturn = super(Conference, self).makebib()
        bibtoreturn['booktitle'] = self.conference
        for key in ['pages', 'url', 'doi', 'biburl']:
            try:
                bibtoreturn[key] = getattr(self, key)
            except:
                pass
        return bibtoreturn

def addcorrectbib(entry):
    if entry['ENTRYTYPE'] == 'inproceedings':
        return Conference(entry)
    else:
        return BibEntry(entry)

class BibDir:

    def __init__(self, bibdirstr: str):
        self.bibdir = Path(bibdirstr)
        if not self.bibdir.is_dir():
            print('Bibliography directory wer? Not at ' + bibdirstr)
            exit(1)

        self.bibs = self.extract_bibs()

    def extract_bibs(self):
        biblist = []
        for bibfile in self.bibdir.iterdir():
            entry = read_bib_file(bibfile)[0]
            biblist.append(addcorrectbib(entry))
        return biblist

    def __repr__(self):
        return '\n'.join([repr(x) for x in self.bibs])

x = '/home/cs/test/'
k = BibDir(x)
print(k)
