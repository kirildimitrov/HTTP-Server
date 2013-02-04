#!/usr/bin/perl 
use warnings;
use strict;
use HTTP::Daemon;
use HTTP::Headers;
use HTTP::Response;

my $port = 8080;
my $addr = "localhost";
my $server=HTTP::Daemon->new(
                            LocalAddr=>$addr,
                            LocalPort=>$port,
                            Listen=>1,
                            Reuse=>1
                              );
die "cannot connect to server" unless $server;
print "connected";
