
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'DBIx::Class::Graph',
    VERSION_FROM      => 'lib/DBIx/Class/Graph.pm', # finds $VERSION
    PREREQ_PM         => {Graph => 0.89,
    	List::MoreUtils => 0,
	Class::C3 => 0,
	Class::Accessor => 0,
	DBIx::Class => 0.080000,
	DBD::SQLite => 0,
	SQL::Translator => 0.08
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/DBIx/Class/Graph.pm', # retrieve abstract from module
       AUTHOR         => 'Moritz Onken <onken@houseofdesign.de>') : ()),
);
