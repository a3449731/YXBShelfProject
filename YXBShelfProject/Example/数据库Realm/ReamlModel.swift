//
//  ReamlModel.swift
//  YXBShelfProject
//
//  Created by 蓝鳍互娱 on 2023/12/26.
//

import RealmSwift

// Object是Realm自封装的，最终还是继承了NSObejct
class ReamlModel: Object {
    // Persisted这个属性包装器里做了，懒加载的初始化，并给了默认值。所以外面不用写初始值也不会报错。好像是通过重写get方法实现的
    
    // 主键
    @Persisted(primaryKey: true) var _id: String
    @Persisted var name: String
    @Persisted var age: Int
    
    // 数组,用list修饰。 比如这个我有很多条狗
    @Persisted var dogs: List<RealDog>
}

// 狗
class RealDog: Object {
    @Persisted var name: String
    @Persisted var age: Int
}
