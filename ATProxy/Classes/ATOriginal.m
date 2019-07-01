//
//  ATOriginal.m
//  ATProxy
//
//  Created by YLCHUN on 2019/7/1.
//

#import "ATOriginal.h"
#import "ATMethodIMP.h"

void atp_original(void(^block)(void)) {
    if (!block) return;
    kATOriginal = YES;
    block();
    kATOriginal = NO;
}
