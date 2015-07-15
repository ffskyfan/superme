@extends('app')


@section('head')
@endsection


@section('content')

    <?php
    ?>


    <div class="container-fluid">
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <div class="panel panel-default">
                    <div class="panel-heading">部署选项</div>
                    <div class="panel-body">

                        @if (count($errors) > 0)
                            <div class="alert alert-danger">
                                <strong>Whoops!</strong> 你的输入有错误哦。<br><br>
                                <ul>
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>

                        @endif


                            <form class="form-horizontal" role="form"  method="post" action="/deploy/deploy">
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">

                                <div class="form-group ">
                                    <div class="col-md-12  well "  >
                                        @foreach ($breads as $idx=>$bread)
                                            @if($idx/3==0)
                                                <div class="row">
                                            @endif


                                                <div class="col-md-2">
                                                    <div class="row">
                                                        <img class="center-block" src="/image/{{ $bread['image'] }}" >
                                                    </div>

                                                    <div class="row input-group input-group-sm">
                                                        <div class="col-md-4">
                                                            </div>

                                                        <span class="input-group-btn ">
                                                            <button class="btn btn-default" type="button">
                                                                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                                                            </button>
                                                        </span>

                                                        <input   type="text" class="form-control" name="{{$idx}}"/>

                                                        <span class="input-group-btn ">
                                                            <button class="btn btn-default" type="button">
                                                                <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
                                                            </button>
                                                        </span>

                                                        <div class="col-md-4">
                                                        </div>
                                                    </div>
                                                </div>

                                            @if($idx/3==0)
                                                </div>
                                            @endif
                                        @endforeach
                                    </div>
                                </div>



                                <div class="form-group  ">
                                    <div class="input-group input-group-sm">
                                        <span class="input-group-addon" id="sizing-addon1">需求点数</span>
                                        <input type="text" class="form-control" placeholder="" aria-describedby="sizing-addon1">
                                    </div>

                                </div>


                                <div class="form-group ">
                                    <div class="col-md-12  well "  >
                                        </div>
                                </div>


                                <div class="form-group">
                                    <div class="col-md-12 col-md-offset-5">
                                        <button type="submit" class="btn btn-primary">
                                            开始计算
                                        </button>
                                    </div>
                                </div>



                        </form>


                    </div>
                </div>
            </div>
        </div>
    </div>


@endsection

@section('scripts')
@endsection
