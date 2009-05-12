package Net::SMS::SMSOnline;

use strict;
use warnings;

use XML::LibXML;
use LWP::UserAgent;
use Carp qw(croak);

our $VERSION = '0.1';

use constant PROC_URL => 'http://sms.smsonline.ru/mt.cgi';

sub new {
    my $class = shift;
    
    my $self = {@_};
    foreach(qw(user pass)) {
        croak "required argument '$_' not specified" unless defined $self->{$_}
    }
    $self->{last_result} = {
        code => undef,
        desc => undef,
    };
    
    bless $self, $class
}

sub send_sms {
    my $self = shift;
    
    my %args = @_;
    my($to, $from, $msg, $notify, $msg_id) = (
        $args{to},
        $args{from},
        $args{msg},
        $args{notify} || 0,
        $args{msg_id} || int rand time,
    );
    
    foreach(qw(to msg)) {
        croak "required argument '$_' not specified" unless defined $args{$_}
    }
    foreach(qw(from to)) {
        croak "'$_' argument must be valid phone in international format" if length $args{$_} > 11
    }
    
    my $ua = LWP::UserAgent->new(agent => sprintf('%s %s', __PACKAGE__, $VERSION));
    my $last_result = $ua->post(
        PROC_URL,
        [user  => $self->{user},
         pass  => $self->{pass},
         phone => $to,
         txt   => $msg,
         dlr   => $notify,
         sn    => $from,
         tid   => $msg_id,],
    );
    unless($last_result->is_success) {
        $self->{last_result}->{code} = $last_result->code;
        $self->{last_result}->{desc} = $last_result->message;
        return 0
    }
    
    my $xml = XML::LibXML->new->parse_string($last_result->content);
    $self->{last_result}->{code} = $xml->findvalue('//reply/code');
    $self->{last_result}->{desc} = $xml->findvalue('//reply/result');
    
    1
}

sub get_last_result { $_[0]->{last_result} }

sub get_last_code { $_[0]->{last_result}->{code} }

sub get_last_desc { $_[0]->{last_result}->{desc} }

1

__END__

=head1 NAME

Net::SMS::SMSOnline - send SMS through smsonline.ru

=head1 SYNOPSIS

    use Net::SMS::SMSOnline;

    my $sms_sender = Net::SMS::SMSOnline->new(
        user => 'my_smsonline_username',
        pass => 'my_smsonline_password',
    );

    my $result = $sms_sender->send_sms(
        to  => '79991112233',
        msg => 'Hello, World!',
    );

=head1 DESCRIPTION

TO FILL

=head1 METHODS

=head2 Constructor

Arguments are:

=over 4

=item * C<user>

    REQUIRED.

=item * C<pass>

    REQUIRED.

=back

=head2 send_sms

Sends your message. Arguments are:

=over 4

=item * C<to>

    REQUIRED. Phone number of the recipient in international format (7 + CODE + PHONE). Must be <= 11 bytes length (numeric only)

=item * C<msg>

    REQUIRED. Text of your message. Note that if length of your message will be > 70 bytes it will be rated as several messages

=item * C<from>

    OPTIONAL. Set your CallerID for this message. Must be <= 11 bytes length (alpha-numeric)

=item * C<notify>

    OPTIONAL. Notify you about status of recently sent messages

=item * C<msg_id>

    OPTIONAL. A unique id of this message

=back

Returns 1 on success and 0 otherwise

=head2 get_last_result

Returns HASHREF with C<code> and C<desc> keys containing code and its description of last sent message

=head2 get_last_code

Returns result code of last sent message

=head2 get_last_desc

Returns stringified description of result code of last sent message

=head1 SEE ALSO

L<http://www.smsonline.ru> - SMSOnline official site

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself

=cut
