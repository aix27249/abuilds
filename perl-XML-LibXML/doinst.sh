libxmlcount=`grep -c XML::LibXML::SAX /usr/lib64/perl5/vendor_perl/XML/SAX/ParserDetails.ini`
if [[ $libxmlcount == 0 ]]; then
    echo ":: Installing SAX XML Parsers"
    /usr/bin/perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::LibXML::SAX::Parser))->save_parsers()"
    /usr/bin/perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::LibXML::SAX))->save_parsers()"
