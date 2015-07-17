@extends('app')


@section('head')
    <style type="text/css">

        input[type=number]::-webkit-outer-spin-button,
        input[type=number]::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

    </style>
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


                            <div class="form-horizontal" role="form"  >
                                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                                <input type="hidden" id="bread_type_count" value="{{ count($breads) }}">

                                <div class="form-group ">
                                    <div class="col-md-12  well "  >
                                        @foreach ($breads as $idx=>$bread)
                                            <?php
                                                $bread_name = "bread_".$idx;
                                            ?>
                                            @if($idx/3==0)
                                                <div class="row">
                                            @endif


                                                <div class="col-md-2" >
                                                    <div class="row ">
                                                        <!--class="center-block"-->
                                                        <div class="center-block">
                                                        <img id="{{$bread_name}}"  src="/image/{{ $bread['image'] }}" >

                                                        <span   class="label  label-info ">{{$bread['great']}}</span>
                                                        <span   class="label  label-warning ">{{$bread['exp']}}</span>
                                                            </div >

                                                    </div>


                                                    <div class="row input-group input-group-sm">
                                                        <div class="col-md-4">
                                                            </div>

                                                        <span class="input-group-btn ">
                                                            <button class="btn btn-default" type="button" onclick="add_bread_number('{{ $bread_name }}')">
                                                                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                                                            </button>
                                                        </span>

                                                        <input type="number" class="form-control" id="{{$bread_name}}_count" value="0"/>
                                                        <input type="hidden" id="{{$bread_name}}_exp" value="{{ $bread['exp'] }}">
                                                        <input type="hidden" id="{{$bread_name}}_critical" value="{{ $bread['great'] }}">
                                                        <input type="hidden" id="{{$bread_name}}_image" value="{{ $bread['image'] }}">

                                                        <span class="input-group-btn ">
                                                            <button class="btn btn-default" type="button" onclick="reduce_bread_number('{{ $bread_name }}')">
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
                                        <input id="exp_need" type="number" value="0" class="form-control" placeholder="" aria-describedby="sizing-addon1">
                                    </div>

                                </div>


                                <div class="form-group "  >
                                    <div class="col-md-12  well "  id="result">
                                    </div>
                                </div>


                                <div class="form-group">
                                    <div class="col-md-12 col-md-offset-5">
                                        <button class="btn btn-primary"  onclick="compute_bread()">
                                            开始计算
                                        </button>
                                    </div>
                                </div>



                        </div>


                    </div>
                </div>
            </div>
        </div>
    </div>


@endsection

@section('scripts')
    {!! Html::script("js/crusaders_bread.js") !!}
@endsection
