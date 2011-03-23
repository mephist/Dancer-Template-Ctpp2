use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Dancer::Template::Ctpp2',
    AUTHOR              => q{Maxim Nikolenko <mnikolenko@agava.com>},
    VERSION_FROM        => 'lib/Dancer/Template/Ctpp2.pm',
    ABSTRACT_FROM       => 'lib/Dancer/Template/Ctpp2.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Dancer'         => 1.175,
        'HTML::CTPP2' => 0,
        'Test::More'     => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Dancer-Template-Ctpp2-*' },
);

