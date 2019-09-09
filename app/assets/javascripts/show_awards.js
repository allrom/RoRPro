$(document).on('turbolinks:load', function() {
    $('.container-main').on('click', '.show_awards', function(e) {
        e.preventDefault();
        $('#awards-given').toggleClass('hidden');
    })
});
