#!/usr/bin/env bash

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
