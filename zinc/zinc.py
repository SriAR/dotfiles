import os
from subprocess import Popen, PIPE

class RSync:
    def __init__(self, start=None, end=None, exclude=None):
        self.itemizeChanges = True
        self.recursive      = True
        self.dryRun         = True
        self.update         = True
        self.omitDirTimes   = True
        self.times          = True
        self.humanReadable  = True
        self.perms          = True
        self.delete         = False
        self.links          = True
        self.exclude        = exclude
        self.start          = start
        self.end            = end

    def build(self):
        command = ['rsync']

        # Boolean Parser
        for key in vars(self).keys():
            value = getattr(self, key)
            if type(value) is bool and value:
                command.append('--' + RSync.capital_to_hyphen(key))

        # Extension Remover
        for extension in self.exclude:
            command.append('--exclude=*'+extension)

        # Add start and end locations
        command.append(self.start)
        command.append(self.end)

        return command

    def location_switch(self):
        self.start, self.end = self.end, self.start
        return

    def capital_to_hyphen(string):
        new_string = []
        for letter in string:
            if letter.isupper():
                new_string.append('-')
            new_string.append(letter.lower())
        return(''.join(new_string))

    def print(self):
        for item in self.__dict__.items():
            print(f"{item[0]}", end = '')
            # 20 is magic number below, adds enough empty space for lining up arrows
            print(f"{''.join([' ' for x in range(20 - len(item[0]))])} -> ", end='')
            print(f"{item[1]}")

class Helper:
    def __init__(self):
        self.file_permissions_available = True
        self.local_changes_only         = None # True if server_to_local, False if local_to_server, None if both
        self.local_folder               = None
        self.remote_folder              = None

    def folder_to_name(self, folder):
        if folder == self.local_folder:
            return 'system'
        elif folder == self.remote_folder:
            return 'server'
        else:
            print('folder_to_name error')
            raise EOFError('wat')

    def print(self):
        for item in self.__dict__.items():
            print(f"{item[0]}", end = '')
            # 27 is magic number below, adds enough empty space for lining up arrows
            print(f"{''.join([' ' for x in range(27 - len(item[0]))])} -> ", end='')
            print(f"{item[1]}")

class ConfigParser:
    def __init__(self, cf_file='.config/zinc/zinc.conf'):
        self.helper = Helper()
        self.rsync  = RSync()
        config_dict = self.to_dict(cf_file)
        self.apply_config(config_dict)

    def apply_config(self, cf_dict):
        # Global Options
        self.helper.local_folder  = os.path.join(os.getenv('HOME'), cf_dict['local_folder']) + '/'
        self.helper.remote_folder = cf_dict['server'] + ':~/' + cf_dict['remote_folder'] + '/'

        if cf_dict['file_permissions_available'] == 'false':
            self.helper.file_permissions_available = False

        direction_dict = {
                        'local-to-server': False,
                        'server-to-local': True,
                        'bidirectional': None
                         }
        self.helper.local_changes_only = direction_dict[cf_dict['default_direction']]

        # RSync options
        self.rsync.exclude = cf_dict['ignore_extensions'].split(',')

    def to_dict(self, cf_file):
        with open(os.path.join(os.getenv('HOME'), cf_file)) as config_file:
            config = config_file.read().splitlines()
        config[:] = map(lambda x: x.split('='), config)
        config_dict = {}
        for x in config:
            config_dict[x[0]] = x[1].strip('"')
        return config_dict

class colors:
    bold       = '\033[1m'
    underline  = '\033[4m'
    red        = '\033[38;5;196m'
    lightgreen = '\033[38;5;47m'
    darkgreen  = '\033[38;5;29m'
    yellow     = '\033[38;5;226m'
    orange     = '\033[38;5;202m'
    darkblue   = '\033[38;5;239m'
    pink       = '\033[38;5;206m'
    purple     = '\033[38;5;201m'
    darkpurple = '\033[38;5;129m'
    lightblue  = '\033[38;5;5m'
    end        = '\033[0m'
    server     = yellow + 'SERVER' + end
    system     = lightgreen + 'SYSTEM' + end
    target     = lightblue + 'TARGET' + end
    dnew       = darkgreen + 'NEW' + end
    fnew       = orange + 'NEW' + end
    size       = pink + 'SIZ' + end
    time       = purple + 'TIM' + end
    fdel       = red + 'DEL' + end

class PrettyPrinter:
    def print_location(line):
        """
        Prints whether the change is happening on
        SERVER or on SYSTEM
        """
        target_options = [colors.server, colors.system, colors.target]

        direction = 1
        if cf.rsync.start == cf.helper.local_folder:
            direction = 0

        target = target_options[direction]
        location = {
                '<': colors.server,
                '>': colors.system,
                '*': target,
                'c': target,
                '.': ''
                   }
        if line[0] in location.keys():
            return location[line[0]]
        else:
            return line[0]

    def print_change(line):
        """
        Prints the change that is happening to the file:
        One of DNEW, FNEW, SIZE, TIME, FDEL
        """
        new_options = {
                'd+++++++++': colors.dnew,
                'f+++++++++': colors.fnew,
                  }

        if line[1:11] in new_options.keys():
            return new_options[line[1:11]]
        elif line[3] == 's':
            return colors.size
        elif line[4] == 't':
            return colors.time
        elif line[1:9] == 'deleting':
            return colors.fdel
        else:
            return line[1:11]

    def pretty_print(line):
        if (len(line)) == 0 or (not cf.helper.file_permissions_available and line[0:11] == '.f...p.....') or (line[1:11] == 'd..t......'):
            return
        print(f"{PrettyPrinter.print_location(line)} {PrettyPrinter.print_change(line)} {line[12:]} ")

class Zinc:
    def __init__(self):
        self.run()
        confirm = input("Would you like to apply these changes [y/N]? Q to quit:")
        if confirm == 'y' or confirm == 'Y':
            cf.rsync.dryRun = False
            print("NOT A DRY RUN")
            self.run()
        else:
            print("e-X11-ting")
            return

    def zinc():
        print(f"Changes from {getattr(colors, cf.helper.folder_to_name(cf.rsync.start))} made at {getattr(colors, cf.helper.folder_to_name(cf.rsync.end))}")

        rsync_command = cf.rsync.build()

        process = Popen(rsync_command, stdout=PIPE, universal_newlines=True)

        while True:
            output = process.stdout.readline()
            PrettyPrinter.pretty_print(output.strip())
            return_code = process.poll()
            if return_code is not None:
                for output in process.stdout.readlines():
                    PrettyPrinter.pretty_print(output.strip())
                break

    def run(self):
        if cf.helper.local_changes_only is None:
            cf.rsync.start, cf.rsync.end = cf.helper.local_folder, cf.helper.remote_folder
            Zinc.zinc()
            cf.rsync.location_switch()
            Zinc.zinc()
        elif cf.helper.local_changes_only:
            cf.rsync.start, cf.rsync.end = cf.helper.remote_folder, cf.helper.local_folder
            Zinc.zinc()
        else:
            cf.rsync.start, cf.rsync.end = cf.helper.local_folder, cf.helper.remote_folder
            Zinc.zinc()

cf = ConfigParser()
Zinc()

#  TODO: Command line argument parser
