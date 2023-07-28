// Customization variables
legendPosX = 0;  // X position of the legend
legendPosY = 0;  // Y position of the legend
legendPosZ = 0;  // Z position of the legend

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

module generate_legend_for_visualization(visualization_infos, legendPos, textColor="black", backgroundColor="white") {
    // Extract the labels and colors from the visualization_infos
    labels = [for (visualization_info = visualization_infos) visualization_info[0]];
    colors = [for (visualization_info = visualization_infos) visualization_info[1]];

    // Now call generate_legend with the extracted labels and colors
    generate_legend(labels, colors, legendPos, textColor, backgroundColor);
}



// Function to generate a legend for color-coded components
module generate_legend(labels, colors, legend_pos, text_color="black", background_color="white") {
    padding = 10;
    average_char_width = 10;
    average_char_height = 15;
    s = 10;
    dy = -15; // Set the step in the y direction    
    max_label_length = max([for (label = labels) len(label)]);
    y_text_offset = -average_char_height - padding;
         
    legend_width = max_label_length * average_char_width + 2 * padding;
    legend_height = len(labels) * average_char_height + 2 * padding; 

    translate(legend_pos) {
        for (i = [0:len(labels)-1]) {
            translate([padding, y_text_offset + i * dy, 0]) {
                color(colors[i]) {
                    cube(s);
                }
                color(text_color) 
                    translate([average_char_height, 0, 0])
                        text(labels[i]);
            }
        }
        color(background_color)
        translate([0, -legend_height, -s]) {
            cube([legend_width, legend_height, 1]); // Background rectangle for better visibility
        }
    }
}





generate_legend(componentLabels, componentColors, [legendPosX, legendPosY, legendPosZ]);

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
        
    

