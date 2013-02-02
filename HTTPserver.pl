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

while(my $client=$server->accept()){
  $client->autoflush(1);
  
  my $request=<$client>;
  if ($request =~ m|^GET /(.+) HTTP/1.[01]|) {
    if(-e $1){
      print $client "HTTP/1.0 200 OK\nContent-Type: text/html\n\n";
      open(my $f, "<$1");
      while(<$f>) { print $client $_ };  
    }else{
        print $client "HTTP/1.0 404 FILE NOT FOUND\n";
        print $client "Content-type: text/plain\n\n";
        print $client "file $1 not found\n";
      }
  }else {
    print $client "HTTP/1.0 400 BAD REQUEST\n";
    print $client "Content-Type: text/plain\n\n";
    print $client "BAD REQUEST!\n";
    print "Client connected\n";   
   }
  close $client;
}

