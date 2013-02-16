#!/usr/bin/perl
use warnings;
use strict;
use IO::Socket;
use Net::hostent;
use LWP::UserAgent;
use HTTP::Request;

my $PORT=8080;

my $server=IO::Socket::INET->new(Proto => 'tcp',
                              LocalPort => $PORT, 
                              Listen =>SOMAXCONN, 
                              Reuse=>1);
die "Can't start server" unless $server;
print "[Server $0 accepting clients at localhost:$PORT]\n";
my $resolved;
while(my $client=$server->accept()){
  $client->autoflush(1); 
  my $request=<$client>;
  if ($request =~ m|^POST /(.+) HTTP/1.[01]|) {
    if(-e $1){ 
      print $client "HTTP/1.0 200 OK\nContent-Type: text/html\n\n";
      print $client "POST request";
      print "POST request";
      $resolved=1;
    }
  else{ 
        print $client "HTTP/1.0 404 FILE NOT FOUND\n";
        print $client "Content-type: text/plain\n\n";
        print "file $1 not found\n";
        print "Can't find this document on the server\n";
        $resolved=1; 
        }
  }
  if($request =~ m|^PUT /(.+) HTTP/1.[01]|){
    if(-e $1){
      print $client "HTTP/1.0 200 OK\nContent-Type: text/html\n\n";
      print $client "PUT request";
      print "PUT request"; 
      $resolved=1;
    }
      else{
          print $client "HTTP/1.0 404 FILE NOT FOUND";
          print $client "Content-type: text/plain\n\n";
          print "file $1 not found";
          print "Can't find this document on the server";
          $resolved=1;
        }   
  } 
  if ($request =~ m|^GET /(.+) HTTP/1.[01]|) {
    if(-e $1){
      print $client "HTTP/1.0 200 OK\nContent-Type: text/html\n\n";
      print "GET request";
      open(my $f, "<$1");
      while(<$f>) { print $client $_ };
      $resolved=1;  
    }else{
        print $client "HTTP/1.0 404 FILE NOT FOUND\n";
        print $client "Content-type: text/plain\n\n";
        print $client "file $1 not found\n";
        print "Can't find this document on server\n";
        $resolved=1;
      }
  }else{
    unless(defined $resolved){
      print $client "HTTP/1.0 400 BAD REQUEST\n";
      print $client "Content-Type: text/plain\n\n";
      print $client "BAD REQUEST!\n";
      print "BAD REQUEST\n";
     }   
  } 
  close $client;
}

