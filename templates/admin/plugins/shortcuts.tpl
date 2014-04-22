<h1>Shortcuts</h1>
<hr />

<form>
  <div class="alert alert-info">
    <p>
      Color of selection-shadow: <input data-key="selectionColor" type="color" /><br>
      Delay between repeating action while key hold down: <input data-key="timeSpace" type="number" step="50" />
    </p>
    <p>
      <h3>Actions</h3>
      <h4>Dialog</h4>
      <div data-key="actions.dialog.confirm" data-type="div" data-new='["27"]' data-attributes='{"data-type": "key", "data-new": "13"}'></div>
    </p>
  </div>
</form>

<button class="btn btn-lg btn-primary" id="save">Save</button>

<script>
  require(['../../plugins/nodebb-plugin-shortcuts/services/AdminSettings'], function(AdminSettings) {
    AdminSettings.init();
  });
</script>