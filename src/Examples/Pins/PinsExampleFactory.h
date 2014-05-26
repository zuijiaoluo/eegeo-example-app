//
//  PinsExampleFactory.h
//  ExampleApp
//
//  Created by Scott on 21/05/2014.
//  Copyright (c) 2014 eeGeo. All rights reserved.
//

#ifndef __ExampleApp__PinsExampleFactory__
#define __ExampleApp__PinsExampleFactory__

#include "IExampleFactory.h"
#include "IExample.h"
#include "EegeoWorld.h"

namespace Examples
{
    class PinsExampleFactory : public IExampleFactory
    {
        Eegeo::EegeoWorld& m_world;
        
    public:
        PinsExampleFactory(Eegeo::EegeoWorld& world);

        std::string ExampleName() const;
        
        IExample* CreateExample() const;
    };
}


#endif /* defined(__ExampleApp__PinsExampleFactory__) */
