$(document).ready(function () {
  const $questions = $("#questions");
  const $form = $questions.find("form");
  const $submitBtn = $questions.find("input[type='submit']");
  const url_answer = $questions.data("answer_url");
  const $questionTitle = $questions.find(".title");
  const $optionsContainer = $questions.find(".options-container");
  const optionMultiple = `
    <div class="column option">
        <div class="ui checkbox">
        <input type="checkbox" name="answer" value="{{ID}}">
        <label class="capitalize">{{TITLE}}</label>
        </div>
    </div>
  `;
  const optionSingle = `
    <div class="column option">
        <div class="ui radio">
        <input type="radio" name="answer" value="{{ID}}">
        <label class="capitalize">{{TITLE}}</label>
        </div>
    </div>
  `;
  let questionFilter = $questions.data("question_filter");
  let currentQuestionPosition = $questions.data("current_position");

  $form.on("submit", function (event) {
    event.preventDefault();

    let answers = [];

    $.each($(this).find('input[name="answer"]:checked'), function () {
      answers.push($(this).val());
    });

    $.post(
      url_answer,
      {
        answer: answers,
        question: { position: currentQuestionPosition, filter: questionFilter },
      },
      function (response) {
        if (response.url_result) {
          window.location.href = response.url_result;
          return;
        }

        currentQuestionPosition = response.position;
        questionFilter = response.question.filter;
        $questionTitle.html(response.question.title);
        $optionsContainer.html("");

        let newOptions = "";

        $.each(response.question.options, function (i, option) {
          if (response.question.type === "multiple-choice") {
            newOptions += optionMultiple
              .replace("{{ID}}", option.id)
              .replace("{{TITLE}}", option.title);
          } else {
            newOptions += optionSingle
              .replace("{{ID}}", option.id)
              .replace("{{TITLE}}", option.title);
          }
        });

        $submitBtn.removeAttr("disabled");
        $optionsContainer.html(newOptions);
      }
    );
  });
});
