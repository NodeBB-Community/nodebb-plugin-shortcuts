<h1>Shortcuts</h1>
<hr />

<form>
  <div class="alert alert-info">
    <p>
      Color of selection-shadow: <input data-key="selectionColor" type="color" /><br>
      Delay between repeating action while key hold down: <input data-key="timeSpace" type="number" step="50" />
    </p>
  </div>
</form>

<button class="btn btn-lg btn-primary" id="save">Save</button>

<script>
  require(['../../plugins/nodebb-plugin-shortcuts/services/AdminSettings'], function(AdminSettings) {
    AdminSettings.init();
  });
</script>