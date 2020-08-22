#!/usr/bin/env ruby

def updateInstall(installer)
    updateInstallWithoutIgnore(installer, [])
end

def updateInstallWithoutIgnore(installer, ignore)
    require 'pathname'
    puts Pathname.new(__FILE__).realpath    

    name = 'AshOrderFile'
    ignore << name

    project = installer.pods_project
    # 获取 AshOrderFile target
    dependTarget = project.targets.find { |t| t.name == name }
    # 若不存在则结束
    if dependTarget.nil?
        return
    end

    # 判断 Podfile 是否使用 use_frameworks!
    dynamic = dependTarget.product_type.include?('framework')
    # 获取 AshOrderFile 的项目引用
    dependReference = dependTarget.product_reference

    # 默认配置
    defaultValues = Hash[
        'OTHER_CFLAGS' => ['$(inherited)'],
        'OTHER_SWIFT_FLAGS' => ['$(inherited)'],
        'ENABLE_BITCODE' => 'NO'
    ]

    # 需要更新的配置
    updateValues = Hash[
        'OTHER_CFLAGS' => '-fsanitize-coverage=func,trace-pc-guard',
        'OTHER_SWIFT_FLAGS' => '-sanitize=undefined -sanitize-coverage=func',
        'ENABLE_BITCODE' => 'NO'
    ]

    if dynamic
        defaultValues['FRAMEWORK_SEARCH_PATHS'] = ['$(inherited)']
        updateValues['FRAMEWORK_SEARCH_PATHS'] = '${PODS_CONFIGURATION_BUILD_DIR}/' + name
    end

    project.targets.each do |target|
        # 去除不需要更新的依赖
        if !ignore.include?(target.name) and !target.name.include?('Pods-')
            
            # 若是动态库，需要添加依赖
            if dynamic and !target.instance_of? Xcodeproj::Project::Object::PBXAggregateTarget
                # 添加依赖引用
                dependency = target.dependency_for_target(dependTarget)
                if !dependency
                    target.add_dependency(dependTarget)
                end
                # 添加 framework
                build_phase = target.frameworks_build_phase
                if build_phase
                    build_phase.add_file_reference(dependReference)
                end
            end

            # 修改 Build Settings
            target.build_configurations.each do |config|
                updateValues.each do |pair|
                    key = pair[0]
                    value = pair[1]
                    # 若当前没有配置，则填充默认配置
                    if config.build_settings[key].nil?
                        config.build_settings[key] = defaultValues[key]
                    end
                    # 添加配置
                    if !config.build_settings[key].include?(value)
                        config.build_settings[key] << value
                    end
                end
            end

        end
    end
end