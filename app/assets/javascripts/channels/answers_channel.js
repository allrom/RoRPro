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
        received: function(data) {
            var answer = $.parseJSON(data);
            if (gon.user_id == answer.user_id) {
               return;
            }
            return $("#answers-table").append(JST["templates/answer"]({ object: answer }));
        }
    });
});
