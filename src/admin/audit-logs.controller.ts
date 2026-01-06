import {
  Controller,
  Get,
  Query,
  Param,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { AuditLogsService } from './audit-logs.service';

@Controller('admin/audit-logs')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AuditLogsController {
  constructor(private readonly auditLogsService: AuditLogsService) {}

  /**
   * Get audit logs with pagination and filters
   */
  @Get()
  async getLogs(
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('admin_id') admin_id?: string,
    @Query('resource_type') resource_type?: string,
    @Query('action') action?: string,
    @Query('start_date') start_date?: string,
    @Query('end_date') end_date?: string,
  ) {
    return this.auditLogsService.getLogs(
      parseInt(page || '1'),
      parseInt(limit || '20'),
      {
        admin_id,
        resource_type,
        action,
        start_date,
        end_date,
      },
    );
  }

  /**
   * Get audit log detail
   */
  @Get(':id')
  async getLogDetail(@Param('id') id: string) {
    return this.auditLogsService.getLogDetail(id);
  }

  /**
   * Get audit log statistics
   */
  @Get('stats/summary')
  async getLogStats(@Query('days') days?: string) {
    return this.auditLogsService.getLogStats(parseInt(days || '30'));
  }
}
