$(document).on('turbolinks:load', function() {
    var onButton = function(e) {
        //console.log(e);
        var resource = e.detail[0];
        $('#amount-question_' + resource.id ).html('<b>Votes: </b>').append(resource.amount, "&nbsp;");
        $('#amount-answer_' + resource.id ).html('<b>Votes: </b>').append(resource.amount, "&nbsp;");
    };

    var onButtonErr = function(e) {
        var xhr = e.detail[2];
        $('.vote-errors').html(xhr.responseText).attr('style', 'color: red');
    };

    $('.upvote').closest('form').on('ajax:success', onButton)
                                .on('ajax:error', onButtonErr);
    $('.downvote').closest('form').on('ajax:success',onButton)
                                .on('ajax:error', onButtonErr);
    $('.dropvote').closest('form').on('ajax:success', onButton)
                                 .on('ajax:error', onButtonErr);
});
