import os
from subprocess import Popen, PIPE
import subprocess

class colors:
    """
    All the colours needed for pretty printing
    the zinc output
    """
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

class ConfigParser:
    def check_config(config_folder=None):
        if not config_folder:
            config_folder = os.path.join(os.getenv('HOME'), '.config/zinc')
        if not os.path.exists(config_folder) and os.path.isdir(config_folder):
            print("Config folder doesn't exist")
            exit
        return config_folder

    def global_variables(config_dict):
        global server, local_folder, remote_folder, ignore_extensions, file_permissions_available, default_direction, folder_to_name
        server        = config_dict['server']
        local_folder  = os.path.join(os.getenv('HOME'), config_dict['local_folder']) + '/'
        remote_folder = server + ':~/' + config_dict['remote_folder'] + '/'
        file_permissions_available = True
        if config_dict['file_permissions_available'] == 'false':
            file_permissions_available = False
        config_dict['ignore_extensions'] = config_dict['ignore_extensions'].split(',')
        ignore_extensions = config_dict['ignore_extensions']
        direction_dict = {
                        'local-to-server': 0,
                        'server-to-local': 1,
                        'bidirectional': 2
                         }
        default_direction = direction_dict[config_dict['default_direction']]
        folder_to_name = {
                        local_folder: 'system',
                        remote_folder: 'server'
                         }

    def parse_config(config_folder=None, config_syntax_check=False):
        config_folder = ConfigParser.check_config(config_folder)
        config_file   = os.path.join(config_folder,'zinc.conf')

        with open(config_file, 'r') as file:
            config = file.readlines()

        config[:] = map(lambda x: x.strip(), config)
        if config_syntax_check:
            config[:] = filter(lambda x: x[0] != '[', config)
            config[:] = filter(lambda x: '=' in x, config)

        config[:] = map(lambda x: x.split('='), config)
        config_dict = {}
        for x in config:
            config_dict[x[0]] = x[1].strip('"')

        ConfigParser.global_variables(config_dict)

        return config_dict

class PrettyPrinter:
    def print_location(line, direction):
        """
        Prints whether the change is happening on
        SERVER or on SYSTEM
        """
        target_options = [colors.server, colors.system, colors.target]
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

    def print_change(line, direction):
        """
        Prints the change that is happening to the file:
        One of DNEW, FNEW, SIZE, TIME, FDEL
        """
        new_options = {
                'd+++++++++': colors.dnew,
                'd..t......': '',
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

    def pretty_print(line, direction=2):
        if (len(line)) == 0 or (not file_permissions_available and line[0:11] == '.f...p.....'):
            return
        print(f"{PrettyPrinter.print_location(line, direction)} {PrettyPrinter.print_change(line, direction)} {line[12:]} ")

class Zinc:
    def argument_parser(start, end, additional_arguments):
        global arguments
        arguments = ['--itemize-changes', '--recursive']
        for (argument, bool_value) in additional_arguments:
            if bool_value:
                arguments.append(argument)
        rsync_command = ['rsync']
        rsync_command = rsync_command + arguments
        for extension in ignore_extensions:
            rsync_command.append('--exclude=*'+extension)
        rsync_command.append(start)
        rsync_command.append(end)
        return rsync_command

    def zinc(start, end, direction, additional_arguments):
        #  print(f"Changes from {getattr(colors, folder_to_name[start])} made at {getattr(colors, folder_to_name[end])}")

        rsync_command = Zinc.argument_parser(start, end, additional_arguments)

        process = Popen(
                rsync_command,
                stdout=PIPE,
                universal_newlines=True)
        dry_run = next(filter(lambda x: x[0] == '--dry-run', additional_arguments))
        if dry_run:
            while True:
                output = process.stdout.readline()
                PrettyPrinter.pretty_print(output.strip(), direction)
                return_code = process.poll()
                if return_code is not None:
                    for output in process.stdout.readlines():
                        PrettyPrinter.pretty_print(output.strip(), direction)
                    break
        else:
            print("NOT A DRY RUN")
            while True:
                output = process.stdout.readline()
                PrettyPrinter.pretty_print(output.strip(), direction)
                return_code = process.poll()
                if return_code is not None:
                    for output in process.stdout.readlines():
                        PrettyPrinter.pretty_print(output.strip(), direction)
                    break

    def manager(direction):
        if direction == 0:
            start, end = local_folder, remote_folder
            Zinc.zinc(start, end, direction, [('--dry-run',True), ('--delete', False)])
        elif direction == 1:
            start, end = remote_folder, local_folder
            Zinc.zinc(start, end, direction, [('--dry-run',True), ('--delete', False)])
        else:
            start, end = local_folder, remote_folder
            Zinc.zinc(start, end, 0, [('--dry-run',True), ('--delete', False), ('--update', True)])
            start, end = remote_folder, local_folder
            Zinc.zinc(start, end, 1, [('--dry-run',True), ('--delete', False), ('--update',True)])
        confirm = input("Do you want to go forward with these changes [Y/n]? Q to quit: ")
        print(confirm)

ConfigParser.parse_config()
Zinc.manager(default_direction)

#  TODO: Command line argument parser
