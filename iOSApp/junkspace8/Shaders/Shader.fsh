//
//  Shader.fsh
//  junkspace8
//
//  Created by Neal McDonald on 8/14/12.
//  Copyright (c) 2012 Neal McDonald. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
