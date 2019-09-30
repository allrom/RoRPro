$(document).on('turbolinks:load', function() {
    App.cable.subscriptions.create('CommentsChannel', {

        connected: function () {
            if (!gon.question_id) {
                return;
            }
            return this.perform('follow', {
                id: gon.question_id
            });
        },
        received: function(data) {
            var comment = $.parseJSON(data);
            if (gon.user_id == comment.user_id) {
               return;
            }
            var parentClass = $('#comments-posted-' + comment.commentable_type + '_' + comment.commentable_id);
            return $(parentClass).append(JST["templates/comment"]({ object: comment }));
        }
    });
});
