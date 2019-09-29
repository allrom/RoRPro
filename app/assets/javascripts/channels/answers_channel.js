$(document).on('turbolinks:load', function() {
    App.cable.subscriptions.create('AnswersChannel', {

        connected: function () {
            if (!gon.question_id) {
                return;
            }
            return this.perform('follow', {
                id: gon.question_id
            });
        },

        disconnected: function () {
            return this.perform('unfollow');
        },

        received: function(data) {
            var answer = $.parseJSON(data);
            if (gon.user_id == answer.user_id) {
               return;
            }
            console.log('Added answer in stream...');
            return $("#answers-table").append(JST["templates/answer"]({ object: answer }));
        }
    });
});
