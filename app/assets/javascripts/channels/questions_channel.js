$(document).on('turbolinks:load', function() {
    App.cable.subscriptions.create('QuestionsChannel', {

        connected: function () {
            return this.perform('follow');
        },
        received: function(data) {
            var question = $.parseJSON(data);
            if (gon.user_id == question.user_id) {
                return;
            }
            return $("#questions-table").append(JST["templates/question"]({ object: question }));
        }
    });
});
