import bibtexparser
from pathlib import Path
import json
import yaml

with open('confs.yaml') as f:
    confdict = yaml.safe_load(f)

def fixconference(confname):
    confname = ''.join(filter(lambda x: str.isalnum(x), confname)).lower()

    for key in confdict.keys():
        if key in confname:
            return confdict[key]
    print(f'{confname} is not in in dict')
    return confname

def fixbibentry(bibentry):
    if bibentry['ENTRYTYPE'] == 'inproceedings':
        bibentry['booktitle'] = fixconference(bibentry['booktitle'])

def read_bib_file(bibfile: Path, customparser=False):
    with bibfile.open() as fp:
        entries = bibtexparser.load(fp).entries
    return entries

x = '/home/cs/WorkingPapers/IncMaxFlow/Ref.bib'
y = read_bib_file(Path(x))
for z in y:
    fixbibentry(z)

bib_db = bibtexparser.bibdatabase.BibDatabase()
bib_db.entries = y

# Create a BibTeX writer
writer = bibtexparser.bwriter.BibTexWriter()
writer.indent = "    "  # Format for better readability

# Convert to BibTeX format
bib_string = writer.write(bib_db)

print(bib_string)

#  self.bibdir = Path(bibdirstr)
#  if not self.bibdir.is_dir():
#      print('Bibliography directory wer? Not at ' + bibdirstr)
#      exit(1)
#
#  self.bibs = self.extract_bibs()
#
#  def extract_bibs(self):
#      biblist = []
#      for bibfile in self.bibdir.iterdir():
#          entry = read_bib_file(bibfile)[0]
#          biblist.append(addcorrectbib(entry))
#      return biblist
#
