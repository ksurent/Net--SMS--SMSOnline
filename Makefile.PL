use inc::Module::Install;

perl_version 5.006;
all_from 'lib/Net/SMS/SMSOnline.pm';
requires 'LWP::UserAgent';
requires 'XML::LibXML';
requires 'Carp';

repository 'http://github.com/ksurent/Net--SMS--SMSOnline';

WriteAll;
