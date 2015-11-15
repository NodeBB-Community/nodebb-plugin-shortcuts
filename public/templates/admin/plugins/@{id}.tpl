<form class="form-horizontal" id="@{id}-settings">
  <div class="row">
    <div class="col-xs-12 col-lg-9">
      <div class="panel panel-default">
        <div class="panel-heading">[[@{id}:name]] [[@{id}:version]] / [[@{id}:settings.main]]</div>
        <div class="panel-body">
          <div class="form-group">
            <label class="col-xs-12 col-sm-5 control-label"
                   for="@{id}-shadow-color">[[@{id}:settings.main.shadowColor]]</label>
            <div class="col-xs-12 col-sm-7">
              <input id="@{id}-shadow-color" class="form-control" type="color" data-key="selectionColor"
                     placeholder="[[@{id}:settings.main.shadowColor.none]]"/>
            </div>
          </div>

          <div class="form-group">
            <label class="col-xs-12 col-sm-5 control-label"
                   for="@{id}-repeat-delay">[[@{id}:settings.main.repeatDelay]]</label>
            <div class="col-xs-12 col-sm-7">
              <input id="@{id}-repeat-delay" class="form-control" type="number" step="1" min="0" data-key="repeatDelay"
                     placeholder="[[@{id}:settings.main.shadowColor.none]]"/>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-xs-12 col-lg-3 visible-lg">
      <div class="panel panel-default">
        <div class="panel-heading">[[plugins:actions.title]]</div>
        <div class="panel-body">
          <div class="form-group">
            <div class="col-xs-12">
              <button type="submit" class="btn btn-primary btn-block @{id}-settings-save" accesskey="s"
                      disabled="disabled">
                <i class="fa fa-fw fa-save"></i> [[plugins:actions.save]]
              </button>
            </div>
          </div>
          <div class="form-group">
            <div class="col-xs-12">
              <button type="button" class="btn btn-warning btn-block @{id}-settings-reset" disabled="disabled">
                <i class="fa fa-fw fa-eraser"></i> [[plugins:actions.reset]]
              </button>
            </div>
          </div>
          <div class="form-group">
            <div class="col-xs-12">
              <button type="button" class="btn btn-danger btn-block @{id}-settings-purge" disabled="disabled">
                <i class="fa fa-fw fa-history"></i> [[plugins:actions.purge]]
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-xs-12">
      <div class="panel panel-default">
        <div class="panel-heading">[[@{id}:settings.actions]]</div>
        <div class="panel-body"><div id="@{id}-actions" class="row"></div></div>
      </div>
    </div>

    <div class="col-xs-12">
      <div class="panel panel-default">
        <div class="panel-heading">[[@{id}:settings.adminActions]]</div>
        <div class="panel-body"><div id="@{id}-admin-actions" class="row"></div></div>
      </div>
    </div>

    <div class="col-xs-12">
      <div class="panel panel-default">
        <div class="panel-heading">[[plugins:actions.title]]</div>
        <div class="panel-body">
          <div class="form-group">
            <div class="col-xs-12">
              <button type="submit" class="btn btn-primary btn-block @{id}-settings-save" accesskey="s"
                      disabled="disabled">
                <i class="fa fa-fw fa-save"></i> [[plugins:actions.save]]
              </button>
            </div>
          </div>
          <div class="form-group">
            <div class="col-xs-12">
              <button type="button" class="btn btn-warning btn-block @{id}-settings-reset" disabled="disabled">
                <i class="fa fa-fw fa-eraser"></i> [[plugins:actions.reset]]
              </button>
            </div>
          </div>
          <div class="form-group">
            <div class="col-xs-12">
              <button type="button" class="btn btn-danger btn-block @{id}-settings-purge" disabled="disabled">
                <i class="fa fa-fw fa-history"></i> [[plugins:actions.purge]]
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</form>

<link rel="stylesheet" type="text/css" href="{relative_path}/plugins/@{name}/static/styles/adminSettings.css"/>
<script type="text/javascript" src="{relative_path}/plugins/@{name}/static/scripts/adminSettings.js"></script>
