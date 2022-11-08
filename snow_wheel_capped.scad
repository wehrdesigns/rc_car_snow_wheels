$fa = 1;
$fs = 0.4;
J = 0.001;

rimR = 76*0.5;    //Radius of inner rim
rimT = 3;     //Thickness of rim
rimW = 40;  //Width of rim without cap thickness
treadW = 10; //Width of tread
treadH = 8; //Height of tread
treadE = 0; //Extend tread on one side of rim
treadO = 1; //Overlap tread into rim
treadN = 8; //Number of treads

capT = 2;   //Thickness of cap
capR = rimR*0.75;  //Radius of inner cutout in cap
cap_screwR = 1.6;     //Radius of cap screw
cap_screwD = 15;    //Depth of cap screw

spikeR = 1.7; //Radius of screw used for ice spike
spikeA = 70;    //Angle of spike screw to make it easier to install
spikeO = 5;    //Offset to move spike screw origin outside of wheel

module wheel(){
    difference()
    {
        union(){
            rim();
            for(i = [1:treadN])
            {
                rotate(a=360/treadN*i)
                tread(rimW+treadE);
            }
        //    translate([0,0,-capT])
        //    cap();
        }
        //Spike screws side 1
        for(i = [1:treadN*0.5])
        {
            rotate(a=360/treadN*i*2)
            spike_side1();
        }
        //Spike screws side 2
        for(i = [1:treadN*0.5])
        {
            rotate(a=360/treadN*i*2+360/treadN*1)
            spike_side2();
        }
        //Cap screws side 1
        for(i = [1:treadN*0.5])
        {            
            rotate(a=360/treadN*i*2+360/treadN)
            translate([rimR+rimT+0.5*(treadH-cap_screwR),0,-J])            
            cylinder(cap_screwD,r=cap_screwR);
        }        
        //Cap screws side 2
        for(i = [1:treadN*0.5])
        {            
            rotate(a=360/treadN*i*2+360/treadN)
            translate([rimR+rimT+0.5*(treadH-cap_screwR),0,rimW-cap_screwD+J])            
            cylinder(cap_screwD,r=cap_screwR);
        }
    }
}

module tread(length = 100){
    translate([-0.5*treadW,rimR+rimT-treadO,0])
    cube([treadW,treadH,length]);
}

module rim(){
    difference()
    {
        cylinder(rimW,r=rimR+rimT);
        translate([0,0,-J])
        cylinder(rimW+2*J,r=rimR);
    }
}

module cap(){
    difference()
    {
        cylinder(capT,r=rimR+rimT+J);
        translate([0,0,-J])
        cylinder(capT+2*J,r=capR);
    }
    difference()
    {
        for(i = [1:treadN])
        {
            rotate(a=360/treadN*i)
            tread(capT);
        }
    //Cap screws side 2
        for(i = [1:treadN*0.5])
        {            
            rotate(a=360/treadN*i*2+360/treadN)
            translate([rimR+rimT+0.5*(treadH-cap_screwR),0,-J])            
            cylinder(cap_screwD,r=cap_screwR);
        }
    }
}

module spike_side1(){
    translate([0,0,-spikeO])
    rotate([0,spikeA,0])
    cylinder(rimW*3,r=spikeR);
}

module spike_side2(){
    translate([0,0,spikeO+rimW])
    rotate([0,180-spikeA,0])
    cylinder(rimW*3,r=spikeR);
}

wheel();

//cap();