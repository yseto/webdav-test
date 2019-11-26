#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Data::Dumper;
use Furl;
use HTTP::Request;
use HTTP::Headers;
use JSON::Types;

use XML::Simple;

my $ua = Furl->new;

my $header = HTTP::Headers->new;
$header->header(Depth => 1);

my $body =<<_BODY_;
<?xml version="1.0" encoding="utf-8"?>
<D:propfind xmlns:D="DAV:">
    <D:prop>
        <D:resourcetype/>
        <D:getcontentlength/>
        <D:getlastmodified/>
    </D:prop>
</D:propfind>
_BODY_

my $req = HTTP::Request->new("PROPFIND" => "http://localhost:8080/bbbb/", $header, $body);
my $res = $ua->request($req);

my $xml = XMLin($res->content, ForceArray => ["D:response"]);

my @directory = map { {
    filename => $_->{'D:href'},
    directory => bool($_->{'D:propstat'}{'D:prop'}{'D:resourcetype'}{'D:collection'}),
    size => number($_->{'D:propstat'}{'D:prop'}{'D:getcontentlength'}),
    mtime => $_->{'D:propstat'}{'D:prop'}{'D:getlastmodified'},
} } @{$xml->{'D:response'}};

warn Dumper @directory;

