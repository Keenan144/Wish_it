$(document).ready(function() {
  login_user();
  edit_user();
  add_wish();
  delete_button();
  add_friend();

  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
});


var login_user = function() {
  $(".main_login_form").on("submit", function(event){
    
    formdata = $(this).serialize()

    $.ajax({
      url: "/login",
      type: "post",
      data: formdata
    })
    .success(function(response) {
      console.log(response)
      console.log("success");
    })
    .fail(function() {
      console.log("error");
    })
    .always(function() {
      console.log("complete");
    })
  });
};

var edit_user = function() {
  $('#profile_name').on('click', 'button', function(event){
    event.preventDefault()


    formdata = $(this).serialize()

    $.ajax({
      url: '/user/' + this.dataset.userId + '/edit',
      type: "put",
      data: formdata
    })
    .success(function(response1) {
      console.log(response1)
      console.log("success")
      $(".profile_wishes").prepend(response1)
      $('.new_wish_form').find('input').eq(0).val('')

    })
    .fail(function() {
      console.log("error");
    })
    .always(function() {
      console.log("complete");
    })
  });
}


  var add_wish = function() {
  $('.new_wish_form').on("submit", function(event){
    event.preventDefault()

    formdata = $(this).serialize()

    user_id = $("#user_id").text()
    $.ajax({
      url: "/user/" + user_id + "/wish",
      type: "post",
      data: formdata

    })
    .success(function(response1) {
      console.log(response1)
      console.log("success")
      $(".profile_wishes").prepend(response1)
      $('.new_wish_form').find('input').eq(0).val('')

    })
    .fail(function() {
      console.log("error");
    })
    .always(function() {
      console.log("complete");
    })
  });
}

var delete_button = function() {
  $('.profile_wishes').on('click', 'button', function(event){
    event.preventDefault();

    var button = this,
      url = '/user/' + this.dataset.userId + '/wish/' + this.dataset.wishId + '/delete';

      $.ajax({
        url: url,
        type: 'delete'
      })
    .success(function(response2) {
      $(button).closest('tr').remove()
      console.log("deleting")
    })
    .fail(function() {
      console.log("error");
    })
    .always(function() {
      console.log("complete");
    })
  });
}


var add_friend = function() {
  $('.friend_me').on('click', 'button', function(event){
    event.preventDefault();
    console.log("clicked");

    var button = this,
    url = '/user/' + this.dataset.userId + '/profile/' + this.dataset.friendId + '/add_friend';

    $.ajax({
      url: url,
      type: 'post',
    })
  .success(function(response3) {
      console.log(response3)
      console.log("friending")
      $('.friend_me').hide()
    })
  .fail(function() {
      console.log("error");
    })
  .always(function() {
      console.log("complete");
    })
  });
}
