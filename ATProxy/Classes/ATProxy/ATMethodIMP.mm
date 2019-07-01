//
//  ATMethodIMP.m
//  ATProxy
//
//  Created by YLCHUN on 2019/6/11.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "ATMethodIMP.h"
#import <objc/runtime.h>
#import <map>

typedef std::map<SEL, IMP> SELIMP;
typedef std::map<Class, SELIMP> IMPContainer;

class IMPCache
{
private:
    IMPContainer cache;
    ~IMPCache();
public:
    IMPCache();
    void set_imp(Class cls, SEL sel, IMP imp);
    IMP get_imp(Class cls, SEL sel);
};

IMPCache::IMPCache() {
    this->cache = IMPContainer();
}

IMPCache::~IMPCache() {
    this->cache.clear();
}

IMP IMPCache::get_imp(Class cls, SEL sel) {
    IMPContainer::iterator itr_cls = this->cache.find(cls);
    if (itr_cls == this->cache.end()) return NULL;
    
    SELIMP::iterator itr_imp = itr_cls->second.find(sel);
    if (itr_imp == itr_cls->second.end()) return NULL;
    
    return itr_imp->second;
}

void IMPCache::set_imp(Class cls, SEL sel, IMP imp) {
    IMPContainer::iterator itr_cls = this->cache.find(cls);
    if (itr_cls == this->cache.end()) {
        this->cache.insert(IMPContainer::value_type(cls, SELIMP()));
        itr_cls = this->cache.find(cls);
    }
    SELIMP::iterator itr_imp = itr_cls->second.find(sel);
    if (itr_imp == itr_cls->second.end()) {
        if (!imp) return;
        itr_cls->second.insert(std::make_pair(sel, imp));
    }else {
        if (imp) return;
        itr_cls->second.erase(itr_imp);
    }
}

static IMP atp_findOrignIMP(Class cls, SEL sel) {
    if (cls == NULL || sel == nil) return NULL;
    uint count = 0;
    IMP orign = NULL;
    Method *list = class_copyMethodList(cls, &count);
    for (int i = count - 1; i >= 0; i--) {
        Method method = list[i];
        SEL name = method_getName(method);
        IMP imp = method_getImplementation(method);
        if (sel_isEqual(name, sel)) {
            orign = imp;
            break;
        }
    }
    free(list);
    return orign;
}

IMP atp_methodOrignImp(Class cls, SEL sel) {
    if (cls == NULL || sel == nil) return NULL;
    
    static IMPCache *impCache = new IMPCache();
    static IMP empty = imp_implementationWithBlock(^{});
    
    IMP imp = impCache->get_imp(cls, sel);
    if (imp == NULL) {
        imp = atp_findOrignIMP(cls, sel);
        if (imp == NULL) {
            imp = empty;
        }
        impCache->set_imp(cls, sel, imp);
    }
    if (imp == empty) return NULL;
    return imp;
}

BOOL kATOriginal = NO;
