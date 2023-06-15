// Customization variables
legendPosX = 200;  // X position of the legend
legendPosY = 200;  // Y position of the legend
legendPosZ = -10;  // Z position of the legend

// Stop customization
module end_of_customization() {}


function visualize_info(label, color_code, alpha=1, mode="as_assembled", show_part_colors=false) = 
    assert(is_string(label))
    assert(is_string(color_code))
    [label, color_code, alpha];
    

module visualize(info) {
    color_code = info[1];
    raw_alpha = info[2];
    alpha = is_num(raw_alpha) ? raw_alpha: 
            is_bool(raw_alpha) && raw_alpha ? 1 :
            0;
    mode = info[3];
    show_part_colors = info[4];
    if (show_part_colors) {
        // Just pass through, so that underlying colors can be seen
        children();
    } else if (alpha == 0) {
        // Don't create anything.  This avoids some artifacts in rendering
        // such as wrong z ordering or not enough convexity being specified.

    } else if (mode=="hidden") {
        // Don't create anything. This allows hiding all visualize parts at once 
    } else {
        color(color_code, alpha) {
            children();
        }
    }
}


module visualize_vitamins(info) {
    raw_alpha = info[2];
    alpha = is_num(raw_alpha) ? raw_alpha: 
            is_bool(raw_alpha) && raw_alpha ? 1 :
            0;
    if (alpha > 0) {
        children();
    }
}



// Function to generate a legend for color-coded components
module generateLegend(labels, colors, legendPos, textColor="black", backgroundColor="white") {
    padding = 10;
    averageCharWidth = 10;
    averageCharHeight = 15;
    maxLabelLength = max([for (label = labels) len(label)]);
    s = 10;
         
    legendWidth = maxLabelLength * averageCharWidth + 2 * padding;
    legendHeight = len(labels) * averageCharHeight + 2 * padding; 

    translate(legendPos) {
        for (i = [0:len(labels)-1]) {
            translate([0, i * 15, 0]) {
                color(colors[i]) {
                    cube(s);
                }
                color(textColor) 
                    translate([15, 0, 0])
                        text(labels[i]);
            }
        }
        color(backgroundColor)
        translate([-padding, -padding, -s]) {
            cube([legendWidth, legendHeight, 1]); // Background rectangle for better visibility
        }
    }
}


generateLegend(componentLabels, componentColors, [legendPosX, legendPosY, legendPosZ]);

// Define component labels and colors
componentLabels = ["Component 1", "Component 2", "Component 3"];
componentColors = ["blue", "green", "red"];



// Main model
module myModel() {
    // Component 1
    color(componentColors[0]) {
        translate([0, 0, 0])
        sphere(20);
    }

    // Component 2
    color(componentColors[1]) {
        translate([-15, -20, 0])
        sphere(15);
    }

    // Component 3
    color(componentColors[2]) {
        translate([15, -20, 0])
        sphere(10);
    }
}




myModel();
        
    

