import time as t
def TimeTakenDecorator(func):
    def wrapper(*args,**kwargs):
        start = t.time()
        func(*args,**kwargs)
        end = t.time()
        print('Time taken for ' + str(func) + ' program: ', end - start)
    return wrapper

import site
site.addsitedir('/usr/lib/python3.10/site-packages/')

from pathlib import Path
import tomllib
from git import Repo

class Project:

    def __init__(self, root: Path, project: dict):
        self.title = project['title']
        self.url = project['url']
        self.root = root
        self.folder = root / project['folder']

    def update(self):
        if not self.is_git_repo():
            self.clone()
            return

        self.repo = Repo(self.folder)
        if self.repo.is_dirty():
            print('Commit changes!')
            return

        self.pull()


    #  @TimeTakenDecorator
    #  This is extremely slow
    #  Takes up to 1.5 seconds for each paper
    def pull(self):
        self.repo.remotes.origin.pull()


    def clone(self):
        print('Cloning to ' + str(self.folder) + ' from ' + self.url)
        Repo.clone_from(self.url, self.folder)


    def is_git_repo(self):
        try:
            _ = Repo(self.folder).git_dir
            return True
        except:
            return False


    def print(self):
        print(self.title)
        print(self.url)
        print(self.folder)


    def __repr__(self):
        return self.title

    #  def update(self):


class Projects:

    def __init__(self, config: str):
        self.config = Path(config)
        if not self.config.is_file():
            print('No config file at ' + config + '!')
            exit(1)

        with open(config, "rb") as f:
            self.rawtoml = tomllib.load(f)

        self.extract_rootfolder()
        self.extract_ongoing()
        self.extract_archived()


    def extract_rootfolder(self):
        rootstr = self.rawtoml['rootfolder']
        self.rootfolder = Path(rootstr)
        self.rootfolder.mkdir(parents=False, exist_ok=True)


    def extract_ongoing(self):
        self.ongoing = []
        ongoingdict = self.rawtoml['current']
        for key in ongoingdict:
            project = ongoingdict[key]
            self.ongoing.append(Project(self.rootfolder, project))


    def extract_archived(self):
        self.archived = []
        for key in self.rawtoml:
            if key == 'current' or key == 'rootfolder':
                continue
            project = self.rawtoml[key]
            self.archived.append(Project(self.rootfolder, project))

    def update(self, scope='ongoing'):
        for project in self.ongoing:
            project.update()
        if scope != 'ongoing':
            for project in self.archived:
                project.update()


    def printraw(self):
        import json
        print(json.dumps(self.rawtoml, sort_keys=True, indent=4))


    def __repr__(self):
        rootfolder = '\n'.join( ['Root folder: '+ str(self.rootfolder), '\n'])
        ongoing = '\n'.join( ['Ongoing:'] + [repr(x) for x in self.ongoing] + ['\n'])
        archived = '\n'.join( ['Archived:'] + [repr(x) for x in self.archived])
        return rootfolder + ongoing + archived

config = '/home/cs/Study/papers.toml'
everything = Projects(config)
everything.update()
