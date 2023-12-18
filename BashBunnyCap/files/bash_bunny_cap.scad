/*
 * Project Name: Bash Bunny Cap
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Bash Bunny didn't come with a cap.  I wanted one, so I made one.
 *
 * Change "enable_ears" to false to remove bunny ears.
 *
 */



// *** VARIABLES *** //
standard_fn = 50;
printgap = 1;

enable_ears = true;

footprint = "bash_bunny_footprint-cleaned.dxf";

usb_dim = [ 4.25 + printgap, 12 + printgap, 11 + printgap ];
collar_dim = [ 7 + printgap, 14 + printgap, 2.5 + printgap ];

extrude_height = usb_dim[2] + collar_dim[2];

import_ctr_offset = [ 9, 12.5, 0 ];

bunny_ear_diam = 10;
bunny_ear_len = extrude_height;
bunny_ear_angle = 10;



// *** MODULES AND FUNCTIONS *** //

module bunny_shadow() {

  linear_extrude(height = extrude_height) {
  
    import(file = footprint);

  }

}



module rounded_top() {

  hull() {
    
    linear_extrude( height = .1 ) {
      
      import(file = footprint);

    }
    
    translate([ import_ctr_offset[0], import_ctr_offset[1], extrude_height / 10])
      scale([ 1, import_ctr_offset[1]/import_ctr_offset[0] , 1 ])
       sphere( extrude_height / 2 - printgap );

  }

}



module usb_cutout() {

  translate([ collar_dim[0] / 2, collar_dim[1] / 2, collar_dim[2] + (usb_dim[2] / 2) ])
    cube(usb_dim, center = true);

  translate([0,0,0])
    cube(collar_dim);

}



module bunny_ear() {

  difference() {
  
    hull() { // Outer ear

      sphere( bunny_ear_diam / 2 );

      translate([ 0, 0, bunny_ear_len ])
        sphere( bunny_ear_diam / 2 );

    }

 
    translate([ bunny_ear_diam / 2, 0, 0 ]) // Inner ear
      hull() { 

        sphere( bunny_ear_diam / 4 );

        translate([ 0, 0, bunny_ear_len ])
          sphere( bunny_ear_diam / 4 );

    }
  }
}



module double_ears() {

  translate([ import_ctr_offset[0], import_ctr_offset[1] - bunny_ear_diam, extrude_height ])
    rotate([ bunny_ear_angle, 0, 0 ])
      bunny_ear();

  translate([ import_ctr_offset[0], import_ctr_offset[1] + bunny_ear_diam, extrude_height ])
    rotate([ 0 - bunny_ear_angle, 0, 0 ])
      bunny_ear();

}



module outer_shape() {

  translate([0,0,0])
    bunny_shadow();

  translate([ 0, 0, extrude_height ])
    rotate([0,0,0])
      rounded_top();
 
  if (enable_ears==true) double_ears();

}



// Build_it function just for testing out each module
// during development.
module build_it() {

  difference() {

    translate([ 0, 1, 0 ])
      outer_shape();
    
    translate( import_ctr_offset / 2 )
      usb_cutout();

    }
  
}



// *** MAIN ***  //
$fn=standard_fn;
build_it();
