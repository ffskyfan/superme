<?php namespace App\Http\Controllers\CrusadersBread;

use App\Http\Controllers\Controller;

class CrusadersBreadController extends Controller {

    /*
    |--------------------------------------------------------------------------
    | Home Controller
    |--------------------------------------------------------------------------
    |
    | This controller renders your application's "dashboard" for users that
    | are authenticated. Of course, you are free to change or remove the
    | controller as you wish. It is just here to get your app started!
    |
    */

    private $breads = [
    1=>["title"=>"Macaroon","rank"=>6,"exp"=>600,"great"=>0,"image"=>"36.png"],
    2=>["title"=>"Hamburger","rank"=>6,"exp"=>480,"great"=>20,"image"=>"16.png"],
    3=>["title"=>"Special Donut","rank"=>6,"exp"=>360,"great"=>40,"image"=>"26.png"],
    4=>["title"=>"Strawberry Pie","rank"=>5,"exp"=>330,"great"=>0,"image"=>"35.png"],
    5=>["title"=>"Pizza","rank"=>5,"exp"=>264,"great"=>20,"image"=>"15.png"],
    6=>["title"=>"Strawberry Donut","rank"=>5,"exp"=>198,"great"=>40,"image"=>"25.png"],
    7=>["title"=>"Cream Bread","rank"=>4,"exp"=>180,"great"=>0,"image"=>"34.png"],
    8=>["title"=>"Sandwich","rank"=>4,"exp"=>144,"great"=>20,"image"=>"14.png"],
    9=>["title"=>"Shamrock Cup Cake","rank"=>4,"exp"=>200,"great"=>30,"image"=>"45.png"],
    10=>["title"=>"Chocolate","rank"=>4,"exp"=>280,"great"=>0,"image"=>"42.png"],
    11=>["title"=>"Choco Cup Cake","rank"=>4,"exp"=>240,"great"=>15,"image"=>"43.png"],
    12=>["title"=>"Big Chocec Cake","rank"=>4,"exp"=>140,"great"=>50,"image"=>"44.png"],
    13=>["title"=>"Christmas Cake","rank"=>4,"exp"=>150,"great"=>25,"image"=>"41.png"],
    14=>["title"=>"Rice Donut","rank"=>4,"exp"=>108,"great"=>40,"image"=>"24.png"],
    15=>["title"=>"Croissant","rank"=>3,"exp"=>100,"great"=>0,"image"=>"33.png"],
    16=>["title"=>"Snack Wrap","rank"=>3,"exp"=>80,"great"=>20,"image"=>"13.png"],
    17=>["title"=>"Jelly","rank"=>3,"exp"=>60,"great"=>40,"image"=>"23.png"],
    18=>["title"=>"Bread","rank"=>2,"exp"=>50,"great"=>0,"image"=>"32.png"],
    19=>["title"=>"Hot Dog","rank"=>2,"exp"=>40,"great"=>20,"image"=>"12.png"],
    20=>["title"=>"Choco Donut","rank"=>2,"exp"=>30,"great"=>40,"image"=>"22.png"],
    21=>["title"=>"Morning Bread","rank"=>1,"exp"=>30,"great"=>0,"image"=>"31.png"],
    22=>["title"=>"Sausage Bread","rank"=>1,"exp"=>24,"great"=>20,"image"=>"11.png"],
    23=>["title"=>"Donut","rank"=>1,"exp"=>18,"great"=>40,"image"=>"21.png"],
    ];


    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard to the user.
     *
     * @return Response
     */
    public function index()
    {
        return view('crusadersbread.main',['breads'=>$this->breads]);
    }

}
