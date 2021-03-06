// Copyright eeGeo Ltd (2012-2016), All Rights Reserved

#include "IndoorAtlasLocationController.h"
#include "InteriorSelectionModel.h"
#include "InteriorInteractionModel.h"
#include <map>
#include <string>

namespace ExampleApp
{
    namespace IndoorAtlas
    {
        IndoorAtlasLocationController::IndoorAtlasLocationController(IndoorAtlasLocationManager& locationManager,
                                                                     ExampleApp::AppModes::SdkModel::IAppModeModel& appModeModel,
                                                                     Eegeo::Resources::Interiors::InteriorInteractionModel& interiorInteractionModel,
                                                                     const Eegeo::Resources::Interiors::InteriorSelectionModel& interiorSelectionModel,
                                                                     const ExampleApp::ApplicationConfig::ApplicationConfiguration& applicationConfiguration)
        : m_locationManager(locationManager)
        , m_appModeModel(appModeModel)
        , m_interiorInteractionModel(interiorInteractionModel)
        , m_interiorSelectionModel(interiorSelectionModel)
        , m_applicationConfiguration(applicationConfiguration)
        , m_appModeChangedCallback(this, &IndoorAtlasLocationController::OnAppModeChanged)
        , m_floorSelectedCallback(this, &IndoorAtlasLocationController::OnFloorSelected)
        {
            m_appModeModel.RegisterAppModeChangedCallback(m_appModeChangedCallback);
            m_interiorInteractionModel.RegisterInteractionStateChangedCallback(m_floorSelectedCallback);
        }
        
        IndoorAtlasLocationController::~IndoorAtlasLocationController()
        {
            m_appModeModel.UnregisterAppModeChangedCallback(m_appModeChangedCallback);
            m_interiorInteractionModel.UnregisterModelChangedCallback(m_floorSelectedCallback);

        }
        
        void IndoorAtlasLocationController::OnAppModeChanged()
        {
            Eegeo::Resources::Interiors::InteriorId interiorId = m_interiorSelectionModel.GetSelectedInteriorId();
            int currentFloorIndex = m_interiorInteractionModel.GetSelectedFloorIndex();
         
            [&m_locationManager StopUpdatingLocation];
         
            if(m_appModeModel.GetAppMode() == AppModes::SdkModel::InteriorMode)
            {
                const std::map<std::string, ExampleApp::ApplicationConfig::SdkModel::ApplicationInteriorTrackingInfo>& trackingInfoMap = m_applicationConfiguration.InteriorTrackingInfo();
                const std::map<std::string, ExampleApp::ApplicationConfig::SdkModel::ApplicationInteriorTrackingInfo>::const_iterator it = trackingInfoMap.find(interiorId.Value());
         
                if(it != trackingInfoMap.end())
                {
                    const ExampleApp::ApplicationConfig::SdkModel::ApplicationInteriorTrackingInfo& trackingInfo = it->second;
         
                    if(trackingInfo.GetType() == "IndoorAtlas")
                    {
                        NSString* apiKey = [NSString stringWithCString:trackingInfo.GetConfig().GetApiKey().c_str() encoding:[NSString defaultCStringEncoding]];
                        NSString* apiSecret = [NSString stringWithCString:trackingInfo.GetConfig().GetApiSecret().c_str() encoding:[NSString defaultCStringEncoding]];
                        std::map<int, std::string> floorMap = trackingInfo.GetFloorIndexMap();
         
                        [&m_locationManager StartUpdatingLocation: apiKey
                                                        apiSecret: apiSecret
                                                         floorMap: floorMap
                                                       floorIndex: currentFloorIndex];
                    }
                }
            }
        }
        
        void IndoorAtlasLocationController::OnFloorSelected()
        {
            int currentFloorIndex = m_interiorInteractionModel.GetSelectedFloorIndex();
            [&m_locationManager SetFloorIndex:currentFloorIndex];
        }
    }
}