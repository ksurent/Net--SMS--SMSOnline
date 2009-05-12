use Test::More tests => 5;

use XML::LibXML;

BEGIN { use_ok('Net::SMS::SMSOnline') }

my $sample_sender;
ok($sample_sender = Net::SMS::SMSOnline->new(user=>'test',pass=>'test'), 'constructor');

my $sample_xml = XML::LibXML->new->parse_string(<<'XML');
<?xml version="1.0" ?>
<reply>
<result>OK</result>
<code>0</code>
</reply>
XML

$sample_sender->{last_result}->{code} = $sample_xml->findvalue('//reply/code');
$sample_sender->{last_result}->{desc} = $sample_xml->findvalue('//reply/result');

ok(ref $sample_sender->get_last_result eq 'HASH', 'get_last_result');
ok($sample_sender->get_last_code == 0, 'get_last_code');
ok($sample_sender->get_last_desc eq 'OK', 'get_last_desc')