#!/usr/bin/env bash

: <<'DOC'
                                        ,   ,
                                        $,  $,     ,
                                        "ss.$ss. .s'
                                ,     .ss$$$$$$$$$$s,
                                $. s$$$$$$$$$$$$$$`$$Ss
                                "$$$$$$$$$$$$$$$$$$o$$$       ,
                               s$$$$$$$$$$$$$$$$$$$$$$$$s,  ,s
                              s$$$$$$$$$"$$$$$$""""$$$$$$"$$$$$,
                              s$$$$$$$$$$s""$$$$ssssss"$$$$$$$$"
                             s$$$$$$$$$$'         `"""ss"$"$s""
                             s$$$$$$$$$$,              `"""""$  .s$$s
                             s$$$$$$$$$$$$s,...               `s$$'  `
                         `ssss$$$$$$$$$$$$$$$$$$$$####s.     .$$"$.   , s-
                           `""""$$$$$$$$$$$$$$$$$$$$#####$$$$$$"     $.$'
                                 "$$$$$$$$$$$$$$$$$$$$$####s""     .$$$|
                                   "$$$$$$$$$$$$$$$$$$$$$$$$##s    .$$" $
                                   $$""$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"   `
                                  $$"  "$"$$$$$$$$$$$$$$$$$$$$S""""'
                             ,   ,"     '  $$$$$$$$$$$$$$$$####s
                             $.          .s$$$$$$$$$$$$$$$$$####"
                 ,           "$s.   ..ssS$$$$$$$$$$$$$$$$$$$####"
                 $           .$$$S$$$$$$$$$$$$$$$$$$$$$$$$#####"
                 Ss     ..sS$$$$$$$$$$$$$$$$$$$$$$$$$$$######""
                  "$$sS$$$$$$$$$$$$$$$$$$$$$$$$$$$########"
           ,      s$$$$$$$$$$$$$$$$$$$$$$$$#########""'
           $    s$$$$$$$$$$$$$$$$$$$$$#######""'      s'         ,
           $$..$$$$$$$$$$$$$$$$$$######"'       ....,$$....    ,$
            "$$$$$$$$$$$$$$$######"' ,     .sS$$$$$$$$$$$$$$$$s$$
              $$$$$$$$$$$$#####"     $, .s$$$$$$$$$$$$$$$$$$$$$$$$s.
   )          $$$$$$$$$$$#####'      `$$$$$$$$$###########$$$$$$$$$$$.
  ((          $$$$$$$$$$$#####       $$$$$$$$###"       "####$$$$$$$$$$
  ) \         $$$$$$$$$$$$####.     $$$$$$###"             "###$$$$$$$$$   s'
 (   )        $$$$$$$$$$$$$####.   $$$$$###"                ####$$$$$$$$s$$'
 )  ( (       $$"$$$$$$$$$$$#####.$$$$$###'                .###$$$$$$$$$$"
 (  )  )   _,$"   $$$$$$$$$$$$######.$$##'                .###$$$$$$$$$$
 ) (  ( \.         "$$$$$$$$$$$$$#######,,,.          ..####$$$$$$$$$$$"
(   )$ )  )        ,$$$$$$$$$$$$$$$$$$####################$$$$$$$$$$$"
(   ($$  ( \     _sS"  `"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$S$$,
 )  )$$$s ) )  .      .   `$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"'  `$$
  (   $$$Ss/  .$,    .$,,s$$$$$$##S$$$$$$$$$$$$$$$$$$$$$$$$S""        '
    \)_$$$$$$$$$$$$$$$$$$$$$$$##"  $$        `$$.        `$$.
        `"S$$$$$$$$$$$$$$$$$#"      $          `$          `$
            `"""""""""""""'         '           '           '
DOC

#######################################################################################
# SYNOPSIS
#
# sometimes you come upon a useful table on the interwebz that you'd like to reference,
#             but it's buried deep within the author's drivel
#
# this tool allows you to locally persist the reference data that you are interested in
# in the form of an HTML page, which utilizes DataTables for search/sort/stripe
#
#######################################################################################
# USAGE
#
#   * use your browser's dev tools to copy the outerHTML of the table in question
#   * save it to a temporary file.  you may also pass it via STDIN, however you may need
#       to tweak the HTML slightly anyway to get it to work with DataTables, so best bet
#       is to save to a scratch file.
#   * from a terminal:
#       hoardeTable < input.html > output.html
#
#       alternatively,
#       <some previous process> | hoardeTable > output.html
#
#       alternatively,
#       hoardeTable $tableHTML > output.html
#
#######################################################################################
# CAVEATS
#
# DataTables can be finnicky, which is why this script removes all HTML attributes
# from your source prior to init'ing the table.  One important thing to note is that
# all tables must have a <thead> in order to function with DataTables.  When you supply
# a table which does not have a <thead> one will be created for you, the first
# <tr> element of the <tbody> will be assumed to contain the table headers (oftentimes true),
# and the <tr> will be removed from the <tbody> and placed into the <thead>.  Didn't turn
# out the way you wanted it to? time to roll up ur sleeves 🪠
#
#######################################################################################
# REMARKS
#
# NO GUARANTEE is made with regard to the functioning of third party resources:
#   * DataTables:       https://datatables.net/
#   * Material Design:  https://m2.material.io/
#   * jQuery:           https://code.jquery.com
#
# stylesheets and javascript resources are linked dynamically.  for a fully functional,
# offline hoarde, you should download all .css and .js resources.
#
#######################################################################################

table=$1

if [ -z "$table" ]
then
  while read -r line; do
    table="""$table
    $line"""
  done
fi

if [ -z "$table" ]
then
  echo """
    USAGE:
      hoardeTable <outerHTML>

    PARAMETERS:
      outerHTML: the HTML table's outerHTML, as copied from the browser.  note that all styles will be stripped.
  """
  exit 0
fi

echo """
  <!DOCTYPE html>
  <html>

  <head>
    <link rel=stylesheet href=https://cdnjs.cloudflare.com/ajax/libs/material-components-web/14.0.0/material-components-web.min.css>
    <link rel=stylesheet href=https://cdn.datatables.net/2.0.3/css/dataTables.material.css>

    <script src=https://code.jquery.com/jquery-3.7.1.js></script>
    <script src=https://cdn.datatables.net/2.0.3/js/dataTables.js></script>
    <script src=https://cdn.datatables.net/2.0.3/js/dataTables.material.js></script>
    <script src=https://cdnjs.cloudflare.com/ajax/libs/material-components-web/14.0.0/material-components-web.min.js></script>
  </head>

  <body>

  $table

  </body>

  <footer>
    <script>
      var removeAttr = jQuery.fn.removeAttr;
      jQuery.fn.removeAttr = function() {

        if (!arguments.length) {
          this.each(function() {

            // Looping attributes array in reverse direction
            // to avoid skipping items due to the changing length
            // when removing them on every iteration.
            for (var i = this.attributes.length -1; i >= 0 ; i--) {
              jQuery(this).removeAttr(this.attributes[i].name);
            }
          });

          return this;
        }

        return removeAttr.apply(this, arguments);
      };
    </script>

    <script>
      let table = jQuery('table')

      jQuery('*', table).removeAttr()

      table.addClass('mdl-data-table');

      if (!jQuery('thead', table).length) {
        let thead = jQuery('<thead></thead>')
          .prependTo(table)

        jQuery('tbody tr:first', table)
          .remove()
          .appendTo('thead')
      }

      new DataTable('table', {
        paging: false
      });

      jQuery('#dt-search-0').focus();
    </script>
  </footer>

  </html>
"""
