use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Net::SMS::SMSOnline',
    VERSION_FROM      => 'lib/Net/SMS/SMSOnline.pm',
    PREREQ_PM         => {
        'LWP::UserAgent' => 0,
	    'XML::LibXML'    => 0,
        'Carp'           => 0,
    },
);
