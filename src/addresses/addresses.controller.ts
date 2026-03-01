import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  UseGuards,
} from '@nestjs/common';
import { AddressesService } from './addresses.service';
import { CreateAddressDto, UpdateAddressDto } from './dto/addresses.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { Profile } from '../decorators/profile.decorator';

@Controller('addresses')
@UseGuards(JwtAuthGuard)
export class AddressesController {
  constructor(private readonly addressesService: AddressesService) {}

  @Get()
  async getAddresses(@Profile() profile: any) {
    return this.addressesService.getAddresses(profile.user_id);
  }

  @Get('default')
  async getDefaultAddress(@Profile() profile: any) {
    const address = await this.addressesService.getDefaultAddress(profile.user_id);
    return { address };
  }

  @Get(':id')
  async getAddressById(@Profile() profile: any, @Param('id') id: string) {
    return this.addressesService.getAddressById(profile.user_id, id);
  }

  @Post()
  async createAddress(@Profile() profile: any, @Body() dto: CreateAddressDto) {
    return this.addressesService.createAddress(profile.user_id, dto);
  }

  @Put(':id')
  async updateAddress(
    @Profile() profile: any,
    @Param('id') id: string,
    @Body() dto: UpdateAddressDto,
  ) {
    return this.addressesService.updateAddress(profile.user_id, id, dto);
  }

  @Delete(':id')
  async deleteAddress(@Profile() profile: any, @Param('id') id: string) {
    return this.addressesService.deleteAddress(profile.user_id, id);
  }

  @Post(':id/set-default')
  async setDefaultAddress(@Profile() profile: any, @Param('id') id: string) {
    return this.addressesService.setDefaultAddress(profile.user_id, id);
  }
}
