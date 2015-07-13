@extends('app')

@section('content')
<div class="container">
	<div class="row">
		<div class="col-md-10 col-md-offset-1">
			<div class="panel panel-default">
				<div class="panel-heading">Home</div>


                <div class="panel-body">

                    <ul id="brood_tab" class="nav nav-tabs">
                        <li class="active">
                            <a href="#servers" data-toggle="tab">
                                克鲁塞德战记
                            </a>
                        </li>

                        <li>
                            <a href="#update" data-toggle="tab">
                                更新
                            </a>
                        </li>





                    </ul>
                    <div id="brood_tab_content" class="tab-content">

                        <div class="tab-pane fade in active" id="servers">
                            <p>

                            <table class="table">
                                <tr>
                                    <th >实用工具</th>
                                </tr>

                                <th>
                                    <form action="crusaders_bread" >
                                        <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                        <input type="hidden" name="usage" value=1/>
                                        <input class="btn btn-primary " type="submit" value="面包计算器"/>
                                    </form><br>
                                </th>

                            </table>

                            </p>
                        </div>





                        <div class="tab-pane fade" id="update">
                            <p>

                            <form action="update" method="post">
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                <input class="btn btn-primary center-block" type="submit" value="更新系统"/>
                            </form><br>

                            </p>
                        </div>

                    </div>


                </div>
            </div>
        </div>

	</div>
</div>
@endsection
