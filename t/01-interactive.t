use Test::More tests => 2;

use Net::SMS::SMSOnline;

SKIP: {
    my($u, $p, $t) = @ENV{'SMSONLINE_USER', 'SMSONLINE_PASS', 'SMSONLINE_PHONE'};

    foreach($u, $p, $t) {
        skip '$ENV{SMSONLINE_USER} or $ENV{SMSONLINE_PASS} or $ENV{SMSONLINE_PHONE} not defined', 1 unless defined
    }

    my $sms = Net::SMS::SMSOnline->new(
        user => $u,
        pass => $p,
    );
    $sms->send_message(
        to  => $p,
        msg => 'Net::SMS::SMSOnline',
    );
    is $sms->get_last_code, 0, 'sent successfully';

    print 'Have you recieved the message? [yes/no] ';
    chomp(my $yes = <STDIN>);
    like $yes, qr/^[yY]/, 'received successfully';
}
