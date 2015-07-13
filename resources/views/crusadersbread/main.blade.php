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

                            <div class="col-md-4 well well-sm  pre-scrollable"  >
                                @foreach ($breads as $idx=>$bread)
                                    <div>
                                        <input  type="checkbox"   name="servers[]" value="{{$idx}}"/>
                                        <span   class="label  label-info">{{$bread['title']}}</span>
                                        <span   class="label  label-danger">{{$bread['exp']}}</span>
                                        <span   class="label  label-success">{{$bread['great']}}</span>

                                    </div>
                                @endforeach

                            </div>


                            <div class="col-md-4 ">

                                <div class="form-group">
                                    <div class="col-md-6 col-md-offset-4">
                                        <button type="submit" class="btn btn-primary">
                                            开始计算
                                        </button>
                                    </div>
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
