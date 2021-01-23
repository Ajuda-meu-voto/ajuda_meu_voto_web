$(document).ready(function () {
  $(".ui.search").search({
    type: "category",
    apiSettings: {
      url: "//localhost:3000/api/v1/search?q={query}",
    },
    minCharacters: 2,
  });
});
