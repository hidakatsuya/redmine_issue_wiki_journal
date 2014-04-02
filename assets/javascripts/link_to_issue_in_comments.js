(function() {
  var comment;
  var re = /#(\d+)/;
  $('.wiki-page-version .comments').each(function() {
    comment = $(this).text();
    if (re.test(comment)) {
      $(this).html(comment.replace(re, '<a href="/issues/$1" title="Open Issue #$1">#$1</a>'));
    }
  });
})();
