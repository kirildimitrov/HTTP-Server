#!/usr/bin/perl
use warnings;
use strict;
use IO::Socket;
use Net::hostent;

my $PORT=8080;

my $server=IO::Socket::INET->new(Proto => 'tcp',
                              LocalPort => $PORT, 
                              Listen =>SOMAXCONN, 
                              Reuse=>1);
die "can't start server" unless $server;
print "[Server $0 accepting clients at localhost:$PORT]\n";
