// $(document).ready(function() {
//     $("#phones a.add_fields").
//       data("association-insertion-position", 'before').
//       data("association-insertion-node", 'this');

//     $('#phones').bind('cocoon:after-insert',
//          function(e, phone) {
//              console.log('inserting new phone ...');
//              $(".member-phone-fields a.add-phone").
//                  data("association-insertion-position", 'after').
//                  data("association-insertion-node", 'this');
//              $(this).find('.member-phone-fields').bind('cocoon:after-insert',
//                   function() {
//                     console.log('insert new phone ...');
//                     console.log($(this));
//                     $(this).find(".phone_from_list").remove();
//                     $(this).find("a.add_fields").hide();
//                   });
//          });

//     $('.member-phone-fields').bind('cocoon:after-insert',
//         function(e) {
//             console.log('replace OLD phone ...');
//             e.stopPropagation();
//             console.log($(this));
//             $(this).find(".phone_from_list").remove();
//             $(this).find("a.add_fields").hide();
//         });
//     //$('body').tabs();
// });