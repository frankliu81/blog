// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require chosen-jquery
//= require posts
//= require jquery-ui
//= require tag-it
//= require_tree .

$(document).ready(function() {

  $('#user-dropdown-button').on('mouseenter', function(){
    $('#user-dropdown-items').slideDown('medidum');
  });

  $('#user-dropdown-menu').on('mouseleave', function(){
    $('#user-dropdown-items').slideUp('medium');
  });


  $.ajax({
      url: "/tags.json",
      dataType: "json",
    }).success(function (data) {

      // get all the tag names before we initialize tagit
      var names = $.map(data, function(element){
        return element.name;
      });

      // create an name to id hash
      // http://stackoverflow.com/questions/26264956/convert-object-array-to-hash-map-indexed-by-an-attribute-value-of-the-object
      //console.log(JSON.stringify(data));
      var names_ids_hash = data.reduce(function(map, obj) {
        map[obj.name] = obj.id
        return map;
      }, {});
      // console.log(JSON.stringify(names_ids_hash));

      //console.log(JSON.stringify(names));
      $("#post-tags").tagit({
          fieldName: "post[tag_ids][]",
          tagLimit: 5,
          beforeTagAdded:
            function(event, ui) {
              if($.inArray(ui.tagLabel, names)==-1) return false;
            },
          // afterTagAdded, we will inject the value for the hidden field
          afterTagAdded:
            function(event, ui) {
              // select the element just added, verify by changing text color
              //$(".tagit-label:contains('" + ui.tagLabel + "')").css("color", "red")

              // select the hidden field just added
              // $("input[class='tagit-hidden-field'][value='butcher-2']")

              // select the hidden field, we will look up the id for the name, via name_id_hash,
              // and then replace the field name with that value
              $("input[class='tagit-hidden-field'][value='" + ui.tagLabel + "']").val(names_ids_hash[ui.tagLabel]);

            },
          //availableTags: names,
          autocomplete:
             { source: function( request, response ) {
                  // match the first few letters
                  // var matches = $.map( names, function( name ) {
                  //   if (name.toUpperCase().indexOf(request.term.toUpperCase()) === 0)
                  //    return name;
                  //  });
                  //  console.log(JSON.stringify(matches));
                  //response(matches);

                  // alternative implementation where we will display the match up top
                  // but will still display other options
                  var matches = [];
                  var no_matches = [];
                  for (var i=0; i<names.length; i++) {
                    name = names[i];
                    if (name.toUpperCase().indexOf(request.term.toUpperCase()) === 0)
                      matches.push(name);
                    else {
                      no_matches.push(name);
                    }
                  }
                  response(matches.concat(no_matches));


               },
              minLength: 1
            }
      });
});




});
