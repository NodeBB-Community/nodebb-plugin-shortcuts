<h1>Shortcuts</h1>
<hr />

<form>
  <div class="alert alert-info">
    <p>
      Color of selection-shadow: <input data-key="selectionColor" type="color" /><br>
    </p>
  </div>
</form>

<button class="btn btn-lg btn-primary" id="save">Save</button>

<script>
  require(['../../plugins/nodebb-plugin-shortcuts/services/AdminSettings'], function(AdminSettings) {
    AdminSettings.init();
  });
</script>