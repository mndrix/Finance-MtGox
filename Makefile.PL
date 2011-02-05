use inc::Module::Install;

name     'Finance-MtGox';
all_from 'lib/Finance/MtGox.pm';
author   q{Michael Hendricks <michael@ndrix.org>};
license  'mit';

build_requires 'Test::More';

auto_install;

WriteAll;

